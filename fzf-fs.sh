#!/usr/bin/env bash

# fzf-fs
# Copyright (C) 2015 D630, The MIT License (MIT)
# <https://github.com/D630/fzf-fs>

# -- DEBUGGING.

#printf '%s (%s)\n' "$BASH_VERSION" "${BASH_VERSINFO[5]}" && exit 0
#set -o xtrace
#exec 2>> ~/fzf-fs.log
#set -o verbose
#set -o noexec
#set -o errexit
#set -o nounset
#set -o pipefail
#trap '(read -p "[$BASH_SOURCE:$LINENO] $BASH_COMMAND?")' DEBUG
#typeset vars_base=$(set -o posix ; set)
#fgrep -v -e "$vars_base" < <(set -o posix ; set) | \
#egrep -v -e "^BASH_REMATCH=" \
#         -e "^OPTIND=" \
#         -e "^REPLY=" \
#         -e "^BASH_LINENO=" \
#         -e "^BASH_SOURCE=" \
#         -e "^FUNCNAME=" | \
#less

# -- SETTINGS.

# -- FUNCTIONS.

# COM Main selection loop.
__fzffs_browse ()
while [[ $pwd ]]
do
    builtin cd -- "$pwd"
    selection=$(__fzffs_select "$pwd")
    case $selection in
        \[..\]*|*..)    pwd=${pwd%/*} ; pwd=${pwd:-$root}       ;;
        \[!]*)          __fzffs_console shell                   ;;
        \[.\]*|*.)      builtin :                               ;;
        \[/\]*)         pwd=$root                               ;;
        \[:\]*)         __fzffs_console console                 ;;
        \[e\]*)         __fzffs_console set set_opener_editor   ;;
        \[o\]*)         __fzffs_console set set_opener_default  ;;
        \[p\]*)         __fzffs_console set set_opener_pager    ;;
        \[q\]*)         pwd=                                    ;;
        \[~\]*)         pwd=$HOME                               ;;
        *)
            child="${pwd}/$(__fzffs_find "$pwd" "${selection%% *}")"
            child=${child//\/\//\/}
            if [[ -d $child ]]
            then
                pwd=$child
            elif [[ -f $child || -p $child ]]
            then
                __fzffs_open_with "$FZF_FS_OPENER" "$child"
            else
                pwd=
            fi
    esac
done

# COM Backend to process console commands coming from the main loop.
__fzffs_console ()
{
    builtin typeset \
        args= \
        fork_background= \
        func= \
        keep= \
        p= \
        pr= \
        terminal= \
        tmp= ;

    case $1 in
        console)    func=console_interactive ;;
        edit)       func=__fzffs_edit        ;;
        page)       func=__fzffs_page        ;;
        open_with)  func=__fzffs_open_with   ;;
        shell)      func=__fzffs_shell       ;;
        terminal)   func=__fzffs_terminal    ;;
        set)        func=__fzffs_set         ;;
        *)          builtin return 1
    esac

    builtin shift 1

    # COM Get arguments via builtin read.
    [[ $func == console_interactive ]] && {
        builtin typeset func="$(command fzf -i --tac --prompt=: --with-nth=1 <<-FUNCTIONS
edit __fzffs_edit fzf-fs-edit
open_with __fzffs_open_with fzf-fs-open
page __fzffs_page fzf-fs-page
set __fzffs_set _
shell __fzffs_shell fzf-fs-shell
terminal __fzffs_terminal _
FUNCTIONS
)"
        builtin set -- ${func}
        func=$2
        pr=$3
        builtin shift 3 2>/dev/null
        [[ ${pr/_/} ]] && {
            if [[ $KSH_VERSION ]]
            then
                tmp=$(command fzf --prompt="$pr " --print-query <<< "")
            elif [[ $ZSH_VERSION ]]
            then
                command tput cup 99999 0
                builtin vared -p "$pr " tmp
            else
                command tput cup 99999 0
                builtin read -re -p "$pr " tmp
            fi
            builtin set -- ${tmp}
        }
    }

    (($# == 0)) || {
        # COM Handle flags.
        [[ ${1:0:1} == - ]] && {
            while builtin read -r -n 1
            do
                case $REPLY in
                    #r)  Run application with root privilege (requires sudo)
                    f)  fork_background=fork_background     ;;
                    k)  keep=keep                           ;;
                    t)  terminal=terminal                   ;;
                    *)  builtin :
                esac
            done <<< "$1"
            builtin shift 1
        }

        # COM Handle macros.
        for p in "$@"
        do
            p=${p//[%][d]/${pwd}}
            p=${p//[%][s]/${child}}
            args="${args}${p} "
        done

        args=${args%% }
        args=\'${args}\'
    }

    ${func} ${args}
}

# COM edit console command.
__fzffs_edit () { builtin eval ${EDITOR} "$@" ; }

__fzffs_find ()
{
    command find \
        -H "${1}/." \
        ! -name . \
        -prune \
        -inum "$2" \
        -exec basename '{}' \; \
        2>/dev/null ;
}

__fzffs_fzf ()
{
    builtin typeset prompt=${1/${HOME}/\~}
    __fzffs_prompt
    command fzf $FZF_FS_DEFAULT_OPTS --prompt="[$prompt] "
}

__fzffs_help ()
{
    { builtin typeset help="$(</dev/fd/0)" ; } <<-HELP
fzf-fs.sh $(__fzffs_version)

Usage:
    fzf-fs.sh [<argument>]
HELP

    __fzffs_echon "$help"
    __fzffs_echoE
}

# COM Output ls and commands into fzf.
__fzffs_ls ()
{
    function __fzffs_ls_do ()
    {
        command ls \
            ${FZF_FS_LS}${FZF_FS_SYMLINK}${ls_hidden}${ls_reverse} | \
        command tail -n +2
    }

    builtin typeset \
        ls_hidden= \
        ls_reverse= ;

    { builtin typeset commands="$(</dev/fd/0)" ; } <<-COMMANDS
_ [!] sh
_ [.] pwd
_ [..] up
_ [/] root
_ [:] console
_ [e] opener editor
_ [p] opener pager
_ [o] opener default
_ [q] quit
_ [~] cd
COMMANDS

    __fzffs_echon "$commands"
    __fzffs_echoE

    if ((FZF_FS_LS_REVERSE == 0))
    then
        ls_reverse=
    else
        ls_reverse=r
    fi

    if ((FZF_FS_LS_HIDDEN == 0))
    then
        ls_hidden=
    else
        ls_hidden=a
    fi

    # COM Do not use tac/tail -r or ls -A (POSIX).
    if [[ $FZF_FS_SORT ]]
    then
        __fzffs_ls_do | command sort $FZF_FS_SORT
    else
        __fzffs_ls_do
    fi
}

__fzffs_main ()
{
    builtin typeset \
        EDITOR=${EDITOR:-nano} \
        FZF_FS_DEFAULT_OPTS="${FZF_FS_DEFAULT_OPTS:--x -i --with-nth=2..}" \
        FZF_FS_LS=${FZF_FS_LS:--li} \
        FZF_FS_SORT=$FZF_FS_SORT \
        FZF_FS_SYMLINK=$FZF_FS_SYMLINK \
        PAGER="${PAGER:-less -R}" \
        TERMINAL=${TERMINAL:-xterm} \
        child= \
        pwd=$1 \
        root=/ \
        selection= \
        source= ;

    builtin typeset FZF_FS_OPENER="${FZF_FS_OPENER:-${PAGER}}"
    builtin typeset FZF_FS_OPENER_DEFAULT="$FZF_FS_OPENER"

    builtin typeset -i \
        FZF_FS_LS_HIDDEN=${FZF_FS_LS_HIDDEN:-1} \
        FZF_FS_LS_REVERSE=${FZF_FS_LS_REVERSE:-1} ;

    builtin typeset -x \
        _fzffs_FZF_DEFAULT_COMMAND_old=$FZF_DEFAULT_COMMAND \
        _fzffs_FZF_DEFAULT_OPTS_old=$FZF_DEFAULT_OPTS \
        _fzffs_LC_COLLATE_old=$LC_COLLATE \
        FZF_DEFAULT_COMMAND='command echo uups' \
        FZF_DEFAULT_OPTS= \
        LC_COLLATE=C ;

    # COM Get the filename of the script, used in version().
    if [[ $BASH_VERSION ]]
    then
        source=${BASH_SOURCE[0]}
        __fzffs_prepare_bash
    elif [[ $ZSH_VERSION ]]
    then
        source=${(%):-%x}
        __fzffs_prepare_zsh
    elif [[ $KSH_VERSION ]]
    then
        # FIXME
        #source=${.sh.file:1}
        source=$0
        __fzffs_prepare_mksh
    fi

    # COM Determine, in which directory we will start.
    if [[ $pwd == .. ]]
    then
        pwd=${PWD%/*}
    elif [[ ${pwd:-.} == . ]]
    then
        pwd=$PWD
    elif [[ -d $pwd ]]
    then
        if [[ ${pwd:${#pwd}-1} == / ]]
        then
            pwd=${pwd%/*}
        else
            pwd=$pwd
        fi
    else
        __fzffs_echon "${source}:Error:79: Not a directory: '${pwd}'" 1>&2
        __fzffs_echoE
        __fzffs_help
        __fzffs_quit
        builtin return 79
    fi

    pwd=${pwd:-$root}

    # COM Go to alternate screen.
    { command tput smcup || command tput ti ; } 2>/dev/null

    # COM Start main loop to select lines.
    __fzffs_browse

    # COM Clean up in the end.
    __fzffs_quit
}

# FIXME COM open_with console command.
__fzffs_open_with () { command $(builtin eval builtin echo "$@") ; }

# COM page console command.
__fzffs_page () { builtin eval ${PAGER} "$@" ; }

# COM create custom bash functions to emulate builtins and stay portable.
__fzffs_prepare_bash ()
{
    __fzffs_echo () { builtin printf '%b\n' "$*" ; }
    __fzffs_echoE () { builtin printf '%s\n' "$*" ; }
    __fzffs_echon () { builtin printf '%s' "$*" ; }
}

# COM create custom mksh functions to emulate builtins and stay portable.
__fzffs_prepare_mksh ()
{
    __fzffs_echo () { builtin print -- "$*" ; }
    __fzffs_echoE () { builtin print -r -- "$*" ; }
    __fzffs_echon () { builtin print -nr -- "$*" ; }
}

# COM create custom zsh functions to emulate builtins and stay portable.
__fzffs_prepare_zsh ()
{
    builtin set -A _fzf_opts_old $(builtin setopt)
    builtin setopt shwordsplit
    __fzffs_echo () { builtin printf '%b\n' "$*" ; }
    __fzffs_echoE () { builtin printf '%s\n' "$*" ; }
    __fzffs_echon () { builtin printf '%s' "$*" ; }
}

# COM Shorten the path displayed as fzf prompt.
__fzffs_prompt ()
{
    # COM Modified _lp_shorten_path() from liquidprompt
    # <https://github.com/nojhan/liquidprompt/blob/master/liquidprompt>

    builtin typeset \
        base= \
        left= \
        mask=" ... " \
        name= \
        ret= \
        tmp= ;

    builtin typeset -i \
        delims= \
        dir= \
        len_left= \
        max_len=$((${COLUMNS:-80} * 35 / 100)) ;

    ((${#prompt} > max_len)) && {
        tmp=${prompt//\//}
        delims=$((${#prompt} - ${#tmp}))

        while ((dir < 2))
        do
            ((dir == delims)) && builtin break
            left=${prompt#*/}
            name=${prompt:0:${#prompt}-${#left}}
            prompt=$left
            ret="${ret}${name%/}/"
            ((dir++))
        done

        if ((delims <= 2))
        then
            ret=${ret}${prompt##*/}
        else
            base=${prompt##*/}
            prompt=${prompt:0:${#prompt}-${#base}}
            [[ $ret == / ]] || ret=${ret%/}
            len_left=$((max_len - ${#ret} - ${#base} - ${#mask}))
            ret="${ret}${mask}${prompt:${#prompt}-${len_left}}${base}"
        fi

        prompt=$ret
    }
}

# COM Cleanup before exit.
__fzffs_quit ()
{
    builtin unset -f \
        __fzffs_browse \
        __fzffs_console \
        __fzffs_echo \
        __fzffs_echoE \
        __fzffs_echon \
        __fzffs_edit \
        __fzffs_find \
        __fzffs_fzf \
        __fzffs_help \
        __fzffs_ls \
        __fzffs_ls_do \
        __fzffs_main \
        __fzffs_open_with \
        __fzffs_page \
        __fzffs_prepare_bash \
        __fzffs_prepare_mksh \
        __fzffs_prepare_zsh \
        __fzffs_prompt \
        __fzffs_quit \
        __fzffs_select \
        __fzffs_set \
        __fzffs_shell \
        __fzffs_terminal \
        __fzffs_version ;

    #trap - EXIT TERM
    #eval "$_fzffs_traps_old"

    [[ $ZSH_VERSION ]] && {
        builtin setopt +o shwordsplit
        for o in "${_fzf_opts_old[@]}"
        do
            builtin setopt "$o"
        done
    }

    builtin typeset -x \
        FZF_DEFAULT_COMMAND=$_fzffs_FZF_DEFAULT_COMMAND_old \
        FZF_DEFAULT_OPTS=$_fzffs_FZF_DEFAULT_OPTS_old \
        LC_COLLATE=$_fzffs_LC_COLLATE_old \
        LC_COLLATE=C ;

    builtin unset -v \
        _fzf_opts_old \
        _fzffs_FZF_DEFAULT_COMMAND_old \
        _fzffs_FZF_DEFAULT_OPTS_old \
        _fzffs_LC_COLLATE_old \
        _fzffs_traps_old \
        o ;
} 2>/dev/null

# COM Pick up a line with fzf.
__fzffs_select ()
{
    __fzffs_ls "$1" | \
    __fzffs_fzf "$1" | \
    command sed 's/^[_ ]*//' ;
}

# COM set console command.
__fzffs_set ()
{
    if [[ $1 ]]
    then
        case $1 in
            set_deference)             FZF_FS_SYMLINK=L                                       ;;
            set_deference_commandline) FZF_FS_SYMLINK=H                                       ;;
            set_lc_collate_c)          LC_COLLATE=C                                           ;;
            set_lc_collate_lang)       LC_COLLATE=$LANG                                       ;;
            set_opener)                FZF_FS_OPENER=interactive                              ;;
            set_opener_pager)          FZF_FS_OPENER=$PAGER                                   ;;
            set_opener_editor)         FZF_FS_OPENER=$EDITOR                                  ;;
            set_opener_default)        FZF_FS_OPENER=$FZF_FS_OPENER_DEFAULT                   ;;
            set_sort)                  FZF_FS_SORT=interactive                                ;;
            show_atime)                FZF_FS_LS=-liu                                         ;;
            show_ctime)                FZF_FS_LS=-lci                                         ;;
            show_hidden)               FZF_FS_LS_HIDDEN=${2:-$((FZF_FS_LS_HIDDEN ? 0 : 1))}   ;;
            show_mtime)                FZF_FS_LS=-li                                          ;;
            sort_atime)                FZF_FS_LS=-liut                                        ;;
            sort_basename)             FZF_FS_LS=-li                                          ;;
            sort_ctime)                FZF_FS_LS=-lcit                                        ;;
            sort_mtime)                FZF_FS_LS=-lit                                         ;;
            sort_reverse)              FZF_FS_LS_REVERSE=${2:-$((FZF_FS_LS_REVERSE ? 0 : 1))} ;;
            sort_size)                 FZF_FS_SORT=-k6,6n                                     ;;
            sort_type)                 FZF_FS_SORT=-k2                                        ;;
        esac
    else
        builtin typeset setting="$(command fzf -i --tac --prompt=: --with-nth=1 <<-SETTINGS
set_deference FZF_FS_SYMLINK=L
set_deference_commandline FZF_FS_SYMLINK=H
set_lc_collate_c LC_COLLATE=C
set_lc_collate_lang LC_COLLATE=$LANG
set_opener FZF_FS_OPENER=interactive
set_opener_pager FZF_FS_OPENER=$PAGER
set_opener_editor FZF_FS_OPENER=$EDITOR
set_opener_default FZF_FS_OPENER=$FZF_FS_OPENER_DEFAULT
set_sort FZF_FS_SORT=interactive
show_atime FZF_FS_LS=-liu
show_ctime FZF_FS_LS=-lci
show_hidden FZF_FS_LS_HIDDEN=$((FZF_FS_LS_HIDDEN ? 0 : 1))
show_mtime FZF_FS_LS=-li
sort_atime FZF_FS_LS=-liut
sort_basename FZF_FS_LS=-li
sort_ctime FZF_FS_LS=-lcit
sort_mtime FZF_FS_LS=-lit
sort_reverse FZF_FS_LS_REVERSE=$((FZF_FS_LS_REVERSE ? 0 : 1))
sort_size FZF_FS_SORT=-k6,6n
sort_type FZF_FS_SORT=-k2
SETTINGS
)"
        builtin eval ${setting#* }
    fi

    if [[ $FZF_FS_SORT == interactive ]]
    then
        FZF_FS_SORT=$(command fzf --prompt="sort " --print-query <<< "")
    elif [[ $FZF_FS_OPENER == interactive ]]
    then
        FZF_FS_OPENER=$(command fzf --prompt="FZF_FS_OPENER " --print-query <<< "")
    fi
}

# COM shell console command.
__fzffs_shell ()
if [[ $terminal == terminal ]]
then
    if [[ $fork_background == fork_background ]]
    then
        (builtin eval ${TERMINAL} -e "${@}\;${keep:+${SHELL:-sh}}" \&)
    else
        builtin eval ${TERMINAL} -e "${@}\;${keep:+${SHELL:-sh}}"
    fi
else
    if [[ $fork_background == fork_background ]]
    then
        (builtin eval ${SHELL:-sh} "${@:+-c $@}" \&)
    else
        builtin eval ${SHELL:-sh} "${@:+-c $@}" ${keep:+\; command printf '%s\\n' \'Press ENTER to continue\' ; builtin read}
    fi
fi

# COM terminal console command.
__fzffs_terminal () (command ${SHELL:-sh} -c ${TERMINAL} &)

# COM Output version of fzf-fs.
__fzffs_version ()
{
    builtin typeset version=v0.1.8

    if [[ $KSH_VERSION ]]
    then
        __fzffs_echon "$version"
        __fzffs_echoE
    else
        builtin typeset md5sum="$(command md5sum "$source")"
        __fzffs_echon "${version} (${md5sum%  *})"
        __fzffs_echoE
    fi
}

# -- MAIN.

__fzffs_main "$1"


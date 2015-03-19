#!/usr/bin/env bash

# fzf-fs
# Copyright (C) 2015 D630, MIT
# <https://github.com/D630/fzf-fs>

# -- DEBUGGING.

#printf '%s (%s)\n' "$BASH_VERSION" "${BASH_VERSINFO[5]}" && exit 0
#set -o xtrace #; exec 2>> ~/fzf-fs.log
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

__fzffs_browse ()
while [[ $pwd ]]
do
    builtin cd -- "$pwd"
    selection=$(__fzffs_select "$pwd")
    case $selection in
        \[..\]*|*..)    pwd=${pwd%/*} ; pwd=${pwd:-$root}   ;;
        \[!]*)          __fzffs_console shell               ;;
        \[.\]*|*.)      builtin :                           ;;
        \[/\]*)         pwd=$root                           ;;
        \[:\]*)         __fzffs_console console             ;;
        \[e\]*)         FZF_FS_OPENER=$EDITOR               ;;
        \[p\]*)         FZF_FS_OPENER=$PAGER                ;;
        \[q\]*)         pwd=                                ;;
        \[~\]*)         pwd=$HOME                           ;;
        *)
            child="${pwd}/$(__fzffs_find "$pwd" "${selection%% *}")"
            child=${child//\/\//\/}
            if [[ -d $child ]]
            then
                pwd=$child
            elif [[ -f $child || -p $child ]]
            then
                __fzffs_open "$child"
            else
                pwd=
            fi
    esac
done

__fzffs_console ()
{
    builtin typeset \
        args= \
        command= \
        p= ;

    case $1 in
        console)    command=console             ;;
        #edit)       command=__fzffs_edit        ;;
        #page)       command=page                ;;
        #open_with)  command=open_with           ;;
        shell)      command=__fzffs_shell       ;;
        terminal)   command=__fzffs_terminal    ;;
        set)        command=__fzffs_set         ;;
        *)          builtin return 1
    esac

    builtin shift 1

    [[ $command == console ]] && {
    builtin typeset command="$(command fzf -i --tac --prompt=: --with-nth=1 --print-query <<-COMMANDS
edit __fzffs_edit
open_with __fzffs_open
page __fzffs_page
set __fzffs_set
shell __fzffs_shell
terminal __fzffs_terminal
COMMANDS
)"
    builtin set -- ${command}
    command=$2
    builtin shift 2 2>/dev/null

    if [[ $command == __fzffs_shell ]]
    then
        builtin set -- $(command fzf --prompt="shell " --print-query <&-)
    fi
}

    (($# == 0)) || {
        for p in "$@"
        do
            p=${p//\%d/${pwd}}
            p=${p//\%s/${child}}
            args="${args} ${p}"
            #%f
            #%c
        done
        builtin printf -v args '%q ' "$args"
    }

    ${command} ${args}
}

__fzffs_edit ()
{
    command $EDITOR
}

__fzffs_file () { command file --mime-type -bL "$1" ; }

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
    command fzf ${FZF_FS_DEFAULT_OPTS} --prompt="[$prompt] "
}

__fzffs_help ()
{
    { builtin typeset help="$(</dev/fd/0)" ; } <<-HELP
fzf-fs.sh $(__fzffs_version)

Usage:
    fzf-fs.sh [<argument>]
HELP

    builtin printf '%s\n' "$help"
}

__fzffs_ls ()
{
    function __fzffs_ls_do
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
_ [e] editor
_ [p] pager
_ [q] quit
_ [~] cd
COMMANDS

    builtin printf '%s\n' "$commands"

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

    # Do not use tac/tail -r or ls -A (POSIX)
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
        EDITOR=${EDITOR:-vi} \
        FZF_FS_DEFAULT_OPTS="${FZF_FS_DEFAULT_OPTS:--x -i --with-nth=2..}" \
        FZF_FS_LS=${FZF_FS_LS:--li} \
        FZF_FS_SORT=$FZF_FS_SORT \
        FZF_FS_SYMLINK=$FZF_FS_SYMLINK \
        PAGER=${PAGER:-less -R} \
        TERMINAL=${TERMINAL:-xterm} \
        child= \
        pwd=$1 \
        root=/ \
        selection= \
        source= ;

    builtin typeset -i \
        FZF_FS_LS_HIDDEN=${FZF_FS_LS_HIDDEN:-1} \
        FZF_FS_LS_REVERSE=${FZF_FS_LS_REVERSE:-1} ;

    builtin typeset FZF_FS_OPENER=${FZF_FS_OPENER:-$PAGER}

    builtin typeset -x \
        _fzffs_FZF_DEFAULT_COMMAND_old=$FZF_DEFAULT_COMMAND \
        _fzffs_FZF_DEFAULT_OPTS_old=$FZF_DEFAULT_OPTS \
        _fzffs_LC_COLLATE_old=$LC_COLLATE \
        FZF_DEFAULT_COMMAND="command echo uups, dead end" \
        FZF_DEFAULT_OPTS= \
        LC_COLLATE=C ;
        #_fzffs_traps_old=$(trap) ;

    #trap -- 'echo quit ; __fzffs_quit' EXIT TERM

    if [[ $BASH_VERSION ]]
    then
        source=${BASH_SOURCE[0]}
    elif [[ $ZSH_VERSION ]]
    then
        source=${(%):-%x}
    #elif [[ $KSH_VERSION ]]
    #then
    #    source=${.sh.file:1}
    else
        source=$0
    fi

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
        builtin printf '%s\n\n' \
            "${source}:Error:79: Not a directory: '${pwd}'" 1>&2
        __fzffs_help
        __fzffs_quit
        builtin return 79
    fi

    pwd=${pwd:-$root}

    { command tput smcup || command tput ti ; } 2>/dev/null

    __fzffs_browse

    __fzffs_quit
}

__fzffs_open () { command $FZF_FS_OPENER "$1" ; }

__fzffs_prompt ()
{
    # Modified _lp_shorten_path() from liquidprompt
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

        for ((dir=0 ; dir < 2 ; dir++))
        do
            ((dir == delims)) && builtin break
            left=${prompt#*/}
            name=${prompt:0:${#prompt}-${#left}}
            prompt=$left
            ret="${ret}${name%/}/"
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

__fzffs_quit ()
{
    builtin unset -f \
        __fzffs_browse \
        __fzffs_console \
        __fzffs_file \
        __fzffs_find \
        __fzffs_fzf \
        __fzffs_help \
        __fzffs_ls \
        __fzffs_main \
        __fzffs_open \
        __fzffs_prompt \
        __fzffs_quit \
        __fzffs_select \
        __fzffs_shell \
        __fzffs_version ;

    #trap - EXIT TERM
    #eval "$_fzffs_traps_old"

    builtin typeset -x \
        FZF_DEFAULT_COMMAND=$_fzffs_FZF_DEFAULT_COMMAND_old \
        FZF_DEFAULT_OPTS=$_fzffs_FZF_DEFAULT_OPTS_old \
        LC_COLLATE=$_fzffs_LC_COLLATE_old \
        LC_COLLATE=C ;

    builtin unset -v \
        _fzffs_FZF_DEFAULT_COMMAND_old \
        _fzffs_FZF_DEFAULT_OPTS_old \
        _fzffs_LC_COLLATE_old \
        _fzffs_traps_old ;
}

__fzffs_select ()
{
    __fzffs_ls "$1" | \
    __fzffs_fzf "$1" | \
    command sed 's/^[_ ]*//' ;
}

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
        FZF_FS_SORT=$(command fzf --prompt="sort " --print-query <&-)
    elif [[ $FZF_FS_OPENER == interactive ]]
    then
        FZF_FS_OPENER=$(command fzf --prompt="FZF_FS_OPENER " --print-query <&-)
    fi
}

__fzffs_shell () {

    builtin typeset \
        fork_background= \
        keep= \
        terminal= ;

    # no getopts here because of printf '%q '
    [[ $1 == \\ && ${2:0:1} == - ]] && {
        while builtin read -r -n 1
        do
            case $REPLY in
                #r)  Run application with root privilege (requires sudo)
                f)  fork_background=fork_background     ;;
                k)  keep=keep                           ;;
                t)  terminal=terminal                   ;;
                *)  builtin :
            esac
        done <<< "$2"
        builtin shift 2
    }

    if [[ $terminal == terminal ]]
    then
        if [[ $fork_background == fork_background ]]
        then
            (builtin eval ${TERMINAL} -e "$@\;${keep:+${SHELL:-sh}}" \&)
        else
            builtin eval ${TERMINAL} -e "$@\;${keep:+${SHELL:-sh}}"
        fi
    else
        if [[ $fork_background == fork_background ]]
        then
            (builtin eval ${SHELL:-sh} "${@:+-c $@}" \&)
        else
            builtin eval ${SHELL:-sh} "${@:+-c $@}" ${keep:+\; builtin read -p \'Press ENTER to continue\'}
        fi
    fi
}

__fzffs_terminal () (command sh -c ${TERMINAL} &)

__fzffs_version ()
{
    builtin typeset md5sum="$(command md5sum "$source")"
    builtin printf '%s (%s)\n'  "v0.1.7" "${md5sum%  *}"
}

# -- MAIN.

__fzffs_main "$1"

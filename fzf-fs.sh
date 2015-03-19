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
        \[!]*)          __fzffs_shell                       ;;
        \[.\]*|*.)      builtin :                           ;;
        \[/\]*)         pwd=$root                           ;;
        \[q\]*)         pwd=                                ;;
        \[~\]*)         pwd=$HOME                           ;;
        \[:\]*)         __fzffs_console                     ;;
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
        FZF_DEFAULT_COMMAND= \
        FZF_DEFAULT_OPTS= ;

    builtin typeset command="$(command fzf -i --tac --prompt=: <<-COMMANDS
set_lc_collate_c LC_COLLATE=C
set_lc_collate_lang LC_COLLATE=$LANG
set_sort FZF_FS_SORT=interactive
show_atime FZF_FS_LS=-laHiu
show_ctime FZF_FS_LS=-lacHi
show_mtime FZF_FS_LS=-laHi
sort_atime FZF_FS_LS=-laHiut
sort_basename FZF_FS_LS=-laHi
sort_ctime FZF_FS_LS=-lacHit
sort_mtime FZF_FS_LS=-laHit
sort_natural
sort_reverse FZF_FS_LS_REVERSE=$((FZF_FS_LS_REVERSE ? 0 : 1))
sort_size
sort_type FZF_FS_LS_TYPE=$((FZF_FS_LS_TYPE ? 0 : 1))
COMMANDS
)"

    builtin eval ${command#* }

    if [[ $FZF_FS_SORT == interactive ]]
    then
        FZF_FS_SORT=$(command fzf --prompt="sort " --print-query <<< "")
    else
        if ((FZF_FS_LS_TYPE == 0))
        then
            FZF_FS_SORT=
        else
            FZF_FS_SORT=-k2
        fi
    fi
}

__fzffs_file () { command file --mime-type -bL "$1" ; }

__fzffs_help ()
{
    { builtin typeset help="$(</dev/fd/0)" ; } <<-HELP
fzf-fs.sh $(__fzffs_version)

Usage:
    fzf-fs.sh [<argument>]
HELP

    builtin printf '%s\n' "$help"
}

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
    builtin typeset \
        prompt=${1/${HOME}/\~} \
        FZF_DEFAULT_COMMAND= \
        FZF_DEFAULT_OPTS= ;

    __fzffs_prompt
    command fzf -x -i --with-nth=2.. --prompt="[$prompt] "
}

__fzffs_ls ()
{
    function __fzffs_ls_do
    {
        command ls ${FZF_FS_LS}${ls_reverse} | command tail -n +2
    }

    builtin typeset ls_reverse=

    #~ builtin printf \
        #~ '_ [%s] %s\n_ [%s] %s\n_ [%s] %s\n_ [%s] %s\n_ [%s] %s\n_ [%s] %s\n_ [%s] %s\n' \
        #~ "!" "sh" \
        #~ "." "pwd" \
        #~ ".." "up" \
        #~ "/" "root" \
        #~ ":" "console" \
        #~ "q" "quit" \
        #~ "~" "cd" ;

    { builtin typeset commands="$(</dev/fd/0)" ; } <<-COMMANDS
_ [!] sh
_ [.] pwd
_ [..] up
_ [/] root
_ [:] console
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

    # Do not use tac/tail -r or ls -A (POSIX)
    if [[ $FZF_FS_SORT ]]
    then
        __fzffs_ls_do | command sort $FZF_FS_SORT ;
    else
        __fzffs_ls_do
    fi
}

__fzffs_main ()
{
    builtin typeset \
        FZF_FS_LS=${FZF_FS_LS:--laHi} \
        FZF_FS_SORT= \
        PAGER=${PAGER:-less -R} \
        child= \
        pwd=$1 \
        root=/ \
        selection= \
        source= ;

    builtin typeset -i \
        FZF_FS_LS_REVERSE=1 \
        FZF_FS_LS_TYPE= ;

    builtin typeset FZF_FS_OPENER=${FZF_FS_OPENER:-$PAGER}

    builtin typeset -x \
        _fzffs_LC_COLLATE_old=$LC_COLLATE \
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

    builtin typeset -x LC_COLLATE=$_fzffs_LC_COLLATE_old

    builtin unset -v \
        _fzffs_LC_COLLATE_old \
        _fzffs_traps_old ;
}

__fzffs_select ()
{
    __fzffs_ls "$1" | \
    __fzffs_fzf "$1" | \
    command sed 's/^[_ ]*//' ;
}

__fzffs_shell () { command "${SHELL:-sh}" ; }

__fzffs_version ()
{
    builtin typeset md5sum="$(command md5sum "$source")"
    builtin printf '%s (%s)\n'  "v0.1.5" "${md5sum%  *}"
}

# -- MAIN.

__fzffs_main "$1"

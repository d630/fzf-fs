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

# -- SETTINGS.

#declare vars_base=$(set -o posix ; set)
#fgrep -v -e "$vars_base" < <(set -o posix ; set) | \
#egrep -v -e "^BASH_REMATCH=" \
#         -e "^OPTIND=" \
#         -e "^REPLY=" \
#         -e "^BASH_LINENO=" \
#         -e "^BASH_SOURCE=" \
#         -e "^FUNCNAME=" | \
#less

# -- FUNCTIONS.

__fzffs_fzf ()
{
    builtin declare \
        prompt="${1:->}" \
        FZF_DEFAULT_COMMAND= \
        FZF_DEFAULT_OPTS= ;

    command fzf -x -i --with-nth=2.. --prompt="${prompt} "
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

__fzffs_ls ()
{
    builtin printf \
        '_ [%s] %s\n_ [%s] %s\n_ [%s] %s\n_ [%s] %s\n_ [%s] %s\n' \
        "." "pwd" \
        ".." "up" \
        "/" "root" \
        "q" "quit" \
        "~" "cd" ;

    # Do not use tac/tail -r and tail -n +2 or ls -A (POSIX)
    command ls -laHi | command sed -n '2!G;h;$p'
}

__fzffs_quit ()
{
    builtin unset -f \
        __fzffs_browse \
        __fzffs_find \
        __fzffs_fzf \
        __fzffs_ls \
        __fzffs_main \
        __fzffs_quit ;

    #trap - EXIT TERM
    #eval "$_fzffs_traps_old"

    builtin declare -xg LC_COLLATE=$_fzffs_LC_COLLATE_old

    builtin unset -v \
        _fzffs_LC_COLLATE_old \
        _fzffs_traps_old ;
}

__fzffs_select ()
{
    __fzffs_ls "$1" | \
    __fzffs_fzf "[${1}]" | \
    command sed 's/^[_ ]*//' ;
}

__fzffs_file ()
{
    command file --mime-type -bL "$1"
}

__fzffs_browse ()
while [[ $pwd ]]
do
    builtin cd -- "$pwd"
    child_ls=$(__fzffs_select "$pwd")
    case $child_ls in
        \[..\]*|*..)
            pwd=${pwd%/*}
            pwd=${pwd:-$root}
            ;;
        \[.\]*|*.)
            :
            ;;
        \[~\]*)
            pwd=$HOME
            ;;
        \[/\]*)
            pwd=$root
            ;;
        \[q\]*)
            pwd=
            ;;
        *)
            child_basename=$(__fzffs_find "$pwd" "${child_ls%% *}")
            if [[ -d ${pwd}/${child_basename} ]]
            then
                pwd=${pwd}/${child_basename}
                pwd=${pwd//\/\//\/}
            elif [[ -f ${pwd}/${child_basename} || \
                -p ${pwd}/${child_basename} ]]
            then
                case $( __fzffs_file "${pwd}/${child_basename}") in
                    image*)
                        command w3m \
                            -o 'ext_image_viewer=off' \
                            -o 'imgdisplay=w3mimgdisplay' \
                            "${pwd}/${child_basename}" ;
                        ;;
                    *)
                        command less -R "${pwd}/${child_basename}"
                esac
            else
                pwd=
            fi
    esac
done

__fzffs_main ()
{
    builtin declare \
        child_ls= \
        child_basename= \
        pwd=$1 \
        root=/ ;

    builtin declare -gx \
        _fzffs_LC_COLLATE_old=$LC_COLLATE \
        LC_COLLATE=C ;
        #_fzffs_traps_old=$(trap) ;

    #trap -- 'echo quit ; __fzffs_quit' EXIT TERM

    if [[ $pwd == .. ]]
    then
        pwd=${PWD%/*}
        pwd=${pwd:-$root}
    elif [[ -z $pwd || $pwd == . ]]
    then
        pwd=$PWD
    elif [[ -d $pwd ]]
    then
        if [[ ${pwd:${#pwd}-1} == / ]]
        then
            pwd=${pwd%/*}
            pwd=${pwd:-$root}
        else
            pwd=$pwd
        fi
    else
        __fzffs_quit
        {
            builtin printf '%s\n' \
            "${BASH_SOURCE:-$0}:Error:79: Not a directory: '${pwd}'" 1>&2
            return 79
        }
    fi

    { command tput smcup || command tput ti ; } 2>/dev/null

    __fzffs_browse

    __fzffs_quit
}

# -- MAIN.

__fzffs_main "$1"

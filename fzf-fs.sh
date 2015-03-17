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

#typeset vars_base=$(set -o posix ; set)
#fgrep -v -e "$vars_base" < <(set -o posix ; set) | \
#egrep -v -e "^BASH_REMATCH=" \
#         -e "^OPTIND=" \
#         -e "^REPLY=" \
#         -e "^BASH_LINENO=" \
#         -e "^BASH_SOURCE=" \
#         -e "^FUNCNAME=" | \
#less

# -- FUNCTIONS.

__fzffs_browse ()
while [[ $pwd ]]
do
    builtin cd -- "$pwd"
    selection=$(__fzffs_select "$pwd")
    case $selection in
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
            child=${pwd}/$(__fzffs_find "$pwd" "${selection%% *}")
            if [[ -d $child ]]
            then
                pwd=$child
                pwd=${pwd//\/\//\/}
            elif [[ -f $child || -p $child ]]
            then
                case $( __fzffs_file "$child") in
                    image*)
                        command w3m \
                            -o 'ext_image_viewer=off' \
                            -o 'imgdisplay=w3mimgdisplay' \
                            "$child" ;
                        ;;
                    *)
                        command less -R "$child"
                esac
            else
                pwd=
            fi
    esac
done

__fzffs_file () { command file --mime-type -bL "$1" ;}

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

__fzffs_main ()
{
    builtin typeset \
        child= \
        pwd=$1 \
        root=/ \
        source= \
        selection= ;

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
        builtin printf '%s\n\n' \
            "${source}:Error:79: Not a directory: '${pwd}'" 1>&2
        __fzffs_help
        __fzffs_quit
        return 79
    fi

    { command tput smcup || command tput ti ; } 2>/dev/null

    __fzffs_browse

    __fzffs_quit
}

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
            ret=${ret}${name%/}/
        done

        if ((delims <= 2))
        then
            ret=${ret}${prompt##*/}
        else
            base=${prompt##*/}
            prompt=${prompt:0:${#prompt}-${#base}}
            [[ $ret == / ]] || ret=${ret%/}
            len_left=$((max_len - ${#ret} - ${#base} - ${#mask}))
            ret=${ret}${mask}${prompt:${#prompt}-${len_left}}${base}
        fi

        prompt=$ret
    }
}

__fzffs_quit ()
{
    builtin unset -f \
        __fzffs_browse \
        __fzffs_file \
        __fzffs_find \
        __fzffs_fzf \
        __fzffs_help \
        __fzffs_ls \
        __fzffs_main \
        __fzffs_prompt \
        __fzffs_quit \
        __fzffs_select \
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

__fzffs_version ()
{
    # Do not use process substitution because of mksh
    builtin typeset md5sum=

    command md5sum "$source" | \
    while builtin read -r md5sum _
    do
        builtin printf '%s (%s)\n'  "vx.x.x.x" "$md5sum"
    done
}

# -- MAIN.

__fzffs_main "$1"

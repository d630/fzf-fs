#!/usr/bin/env bash

# Use fzf (>= v0.8.6) to interactively browse parts of your file system
# Mentioned here: https://github.com/junegunn/fzf/issues/70

# -- DEBUGGING.

#printf '%s (%s)\n' "$BASH_VERSION" "${BASH_VERSINFO[5]}" && exit 0
#set -o xtrace #; exec 2>> ~/fsfzf.log
#set -o verbose
#set -o noexec
#set -o errexit
#set -o nounset
#set -o pipefail
#trap '(read -p "[$BASH_SOURCE:$LINENO] $BASH_COMMAND?")' DEBUG

# -- SETTINGS.

#declare vars_base=$(set -o posix ; set)
#declare -x LC_ALL=C

# -- FUNCTIONS.

__fsfzf_menu_cmd() { sort -b | fzf -x -i +s --prompt="${1:->} " ; }

__fsfzf_find_inum()
{
    find -H "$1" -mindepth 1 -maxdepth 1 -inum "$2" -printf '%f\n' 2>/dev/null
}

__fsfzf_find_child_ls()
{
    printf '%s\n%s\n' '[.]' '[..]'
    find -H "$1" -mindepth 1 -maxdepth 1 -ls
}

__fsfzf_browse()
{
    declare \
        child_ls= \
        child_name= \
        pwd=$1 \
        root=/

    if [[ -d $pwd ]]
    then
        [[ $pwd == . ]] && pwd=$PWD
        [[ $pwd == .. ]] && pwd=${PWD%/*} && pwd=${pwd:-$root}
        [[ ${pwd:0:1} == / ]] || pwd=${PWD}/${pwd}
        [[ ${pwd:${#pwd}-1} == / ]] && pwd=${pwd%/*} && pwd=${pwd:-$root}
    else
        pwd=$PWD
    fi

    child_name=$pwd

    while [[ $child_name ]]
    do
        read -r child_ls < <(__fsfzf_find_child_ls "$pwd" | __fsfzf_menu_cmd "[${pwd}]")
        case $child_ls in
            \[.\])
                    :
                    ;;
            \[..\])
                    pwd=${pwd%/*}
                    pwd=${pwd:-$root}
                    ;;
            *)
                    child_name=$(__fsfzf_find_inum "$pwd" "${child_ls%% *}")
                    if [[ -d ${pwd}/${child_name} ]]
                    then
                        pwd=${pwd}/${child_name}
                        pwd=${pwd//\/\//\/}
                    else
                        case $(file --mime-type -bL "${pwd}/${child_name}") in
                            image*)
                                    w3m -o 'ext_image_viewer=off' \
                                        -o 'imgdisplay=w3mimgdisplay' \
                                        "${pwd}/${child_name}"
                                    ;;
                            *)
                                    LESSOPEN='"| /usr/bin/lesspipe %s"' \
                                    less -R "${pwd}/${child_name}"
                        esac
                    fi
        esac
        builtin cd -- "$pwd"
    done
}

# -- MAIN.

__fsfzf_browse "$1"

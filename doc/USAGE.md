"fzf-fs" "1" "Sun Mar 22 01:23:51 CET 2015" "0.1.8" "USAGE"

##### USAGE

`[source] fzf-fs.sh [<directory>]`

Starting fzf-fs is very easy. Just execute or source `fzf-fs.sh` with one or without dir argument. I am using it in bash with

```sh
alias f='. fzf-fs.sh'
```

After starting up, you are confronted with a list of file and command entries in a cursed-based fullscreen session of fzf. I call it "the main browser pane"; it runs in a while loop and is the starting as well as the endpoint of each session:

```
  drwxr-xr-x  4 user1 user1  4096 Mar 22 01:09 .
  drwxr-xr-x 23 user1 user1  4096 Mar 11 01:00 ..
  drwx------  8 user1 user1  4096 Mar 21 09:26 .git
  -rwx------  1 user1 user1  2149 Mar 22 00:45 README.md
  drwx------  2 user1 user1  4096 Mar 22 01:07 doc
  -rwx------  1 user1 user1 15781 Mar 22 01:09 fzf-fs.sh
  [~] cd
  [q] quit
  [o] opener default
  [p] opener pager
  [e] opener editor
  [:] console
  [/] root
  [..] up
  [.] pwd
> [!] sh
  16/16
[~/var/code/projects/fzf-fs] ::
```

Since there is no way in fzf to configure own keybindings, you may only browse your file system by selecting lines in the browser. It is like cd-ing on the command line, but it is ultra fast and has all fuzzy matching and extended-searching qualities of fzf. If a list entry points to a regular file or named pipe, your configured environment variables come into play; you should set the environment variable FZF_FS_OPENER at least. If you are in the dark, what opener to use, have a look at [this](https://wiki.archlinux.org/index.php/xdg-open). Entries, which begin with a bracket, are internal pointers and have the form `[<shortcut>] <tag> ... <tag>n`:

```
[!]     Fork SHELL in the current directory
[..]    Move to parent directory
[.]     Reload current directory
[/]     Move to /
[:]     Open the console
[e]     Set FZF_FS_OPENER to EDITOR
[o]     Reset FZF_FS_OPENER to the default
[p]     Set FZF_FS_OPENER to PAGER
[q]     Quit
[~]     Move to HOME
```

The file type indicators in the first column are (as either of us knows):

```
-        regular file
?        some other file type
C        high performance ('contiguous data') file
D        door (Solaris 2.5 and up)
M        off-line ('migrated') file (Cray DMF)
P        port (Solaris 10 and up)
b        block special file
c        character special file
d        directory
l        symbolic link
n        network special file (HP-UX)
p        FIFO (named pipe)
s        socket
```

(Obligatory question: Have you ever seen a real Solaris system? Me neither...)

##### OPTIONS

FIXME

##### FLAGS

Some internal commands may be used with own options to determine their process:

```
f   Execute process in background
k   Keep the process. Wait for a key press or spawn a new shell instance
t   Run process in a new terminal emulator window
```

Flags are always placed as first argument to the command and will be parsed before macro pattern substitution.

##### MACROS

Macros are placeholder strings and used in internal commands to point to internal variables:

```
%d  The path of the current working directory
%s  The last directly selected file (or directory) entry
```

Each occurrence of a macro will be replaced.

##### CONSOLE COMMANDS

```
console                     internal command to show console command listing
edit <file>                 Edit file in EDITOR
page <file>                 Open file in PAGER
open_with <list>            FIXME
shell [-flags] <list>       Execute SHELL
terminal                    Execute TERMINAL in the background. Open its shell
                            in the current directory
set <option>                Set/Toggle an option
```

##### SETTINGS

With the internal set command these internal settings may be set:

```
set_deference               FZF_FS_SYMLINK=L
set_deference_commandline   FZF_FS_SYMLINK=H
set_lc_collate_c            LC_COLLATE=C
set_lc_collate_lang         LC_COLLATE=LANG
set_opener_default          FZF_FS_OPENER=FZF_FS_OPENER_DEFAULT
set_opener_editor           FZF_FS_OPENER=EDITOR
set_opener_pager            FZF_FS_OPENER=PAGER
show_atime                  FZF_FS_LS=-liu
show_ctime                  FZF_FS_LS=-lci
show_hidden                 FZF_FS_LS_HIDDEN=$((FZF_FS_LS_HIDDEN ? 0 : 1))
show_mtime                  FZF_FS_LS=-li
sort_atime                  FZF_FS_LS=-liut
sort_basename               FZF_FS_LS=-li
sort_ctime                  FZF_FS_LS=-lcit
sort_mtime                  FZF_FS_LS=-lit
sort_reverse                FZF_FS_LS_REVERSE=$((FZF_FS_LS_REVERSE ? 0 : 1))
sort_size                   FZF_FS_SORT=-k6,6n
sort_type                   FZF_FS_SORT=-k2
```

Interactively:

```
set_opener                  FIXME
set_sort                    Note that the first column of ls in the browser is
                            internally the second column; the first column
                            shows the inode number like in ls -li
```

##### ENVIRONMENT

Currently, there is no configuration file in fzf-fs. But you can set the following environment variables:

```
EDITOR                      Fallback: nano
FZF_DEFAULT_COMMAND         Internallly set to: command echo uups
FZF_DEFAULT_OPTS            Internallly unset
FZF_FS_DEFAULT_OPTS         Addional fzf options in the main loop. --prompt and
                            --with-nth cannot be used. Fallback: -x -i
FZF_FS_LS                   Needs to have the options -l and -i. Fallback: -li
FZF_FS_LS_HIDDEN            0/1. Fallback: 1
FZF_FS_LS_REVERSE           0/1. Fallback: 1
FZF_FS_OPENER               Fallback: PAGER
FZF_FS_SORT                 See set_sort setting in setting section.
                            Fallback: NULL
FZF_FS_SYMLINK              Fallback: NULL
LC_COLLATE                  Internallly set to: C
PAGER                       Fallback: less -R
TERMINAL                    Fallback: xterm
```

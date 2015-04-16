"fzf-fs" "1" "Thu Apr 16 11:09:48 UTC 2015" "0.2.2" "USAGE"

##### USAGE

```sh
Usage
    [ . ] fzf-fs [ -h | -i | -v | <directory> ]

Options
    -h, --help      Show this instruction
    -i, --init      Initialize configuration directory
    -v, --version   Print version

Environment variables
    FZF_FS_CONFIG_DIR
            ${XDG_CONFIG_HOME:-${HOME}/.config}/fzf-fs.d
```

At first, put `fzf-fs` and `fzf-fs-init` on your PATH and initialize the config and working directory with

```sh
fzf-fs --init
```

To source `fzf-fs`, you may use a shell alias like

```sh
alias f='. fzf-fs'
```

and run it like

```sh
f
f .
f ..
f -
f /
```

After starting up, you are confronted with a list of file and command entries in a cursed-based fullscreen session of fzf. I call it the "browser pane"; it runs in a while loop and is the starting as well as the endpoint of each session:

```
  drwxr-xr-x  4 user1 user1  4096 Mar 22 01:09 .
  drwxr-xr-x 23 user1 user1  4096 Mar 11 01:00 ..
  drwx------  8 user1 user1  4096 Mar 21 09:26 .git
  -rwx------  1 user1 user1  2149 Mar 22 00:45 README.md
  drwx------  2 user1 user1  4096 Mar 22 01:07 doc
  -rwx------  1 user1 user1 15781 Mar 22 01:09 fzf-fs.sh
  [-] console/cd $OLDPWD
  [~] console/cd $HOME
  [q] quit
  [:] console
  [/] console/cd $browser_root
> [!] console/shell
  12/12
[~/var/code/projects/fzf-fs] ::
```

You may only browse your file system by selecting lines in the browser. It is like cd-ing on the command line, but with all fuzzy matching and extended-searching qualities of fzf. You should set the environment variable FZF_FS_OPENER at least to open files. If you are in the dark, what opener to use, have a look at [this](https://wiki.archlinux.org/index.php/xdg-open). Entries, which begin with a bracket, refer to configurable console commands. See also section [SHORTCUTS](#shortcuts).

If you have problems with displaying the ls output, have a look at the environment variables FZF_FS_LS_COMMAND and FZF_FS_LS_COMMAND_COLOR. They are preconfigured after `fzf-fs --init`.

##### ENVIRONMENT

You can set the following environment variables on the command line or modify them in `env/env.user`:

```
EDITOR                      Fallback: nano
FZF_DEFAULT_COMMAND         Internally set to: "command echo uups"
FZF_DEFAULT_OPTS            Internally unset
FZF_FS_DEFAULT_OPTS         Additional fzf options in the browser pane. --prompt
                            and --with-nth cannot be used. Fallback: "-x -i"
FZF_FS_LS_CLICOLOR          0/1. Fallback: 1
FZF_FS_LS_COMMAND           Default ls command, depends on your OS and version of
                            ls. In GNU ls it is "ls --color=auto"; on FreeBSD
                            and alike it is "ls -G". See fzf-fs-init
FZF_FS_LS_COMMAND_COLOR     In GNU ls it is "ls --color=always"; on FreeBSD and
                            alike it is "CLICOLOR_FORCE=1 ls -G". See fzf-fs-init
FZF_FS_LS_HIDDEN            0/1. Fallback: 1
FZF_FS_LS_OPTS              Additional ls options in the browser pane. l and i
                            cannot be used. Fallback: NULL
FZF_FS_LS_REVERSE           0/1. Fallback: 1
FZF_FS_LS_SYMLINK           Fallback: NULL
FZF_FS_OPENER               Fallback: PAGER
FZF_FS_OPENER_CONSOLE       Fallback: NULL
FZF_FS_OS                   Output of "uname -s". Fallback: "Linux"
FZF_FS_SORT                 See sort_interactive in the setting section.
                            Fallback: NULL
LC_COLLATE                  Internally set to: "C"
PAGER                       Fallback: "less -R"
TERMINAL                    Fallback: "xterm"
```

FZF_FS_CONFIG_DIR needs to be set on the command line. Default value is `${XDG_CONFIG_HOME:-${HOME}/.config}/fzf-fs.d`.

##### CONSOLE COMMANDS

```
cd <file>                   Change the working directory in the browser pane
console                     Show the console pane
edit <file>                 Edit file in EDITOR
open_with <list>            Execute command list in the current shell. When used
                            inside of the browser pane, FZF_FS_OPENER will be
                            read.
page <file>                 Open file in PAGER
shell [-flags] <list>       Execute SHELL
terminal                    Execute TERMINAL in the background. Open its shell
                            in the current directory of the browser pane
set <option>                Set/Unset/Toggle an option
```

You can modify these default commands or create your own. Commands are stored in the directory `console/`. See section [SCRIPTING](#scripting).

##### SETTINGS

With the internal `set` command, placed in `console/set/`, these default settings may be used:

```
clicolor_force_false        FZF_FS_LS_CLICOLOR=0
clicolor_force_toggle       FZF_FS_LS_CLICOLOR=$((FZF_FS_LS_CLICOLOR ? 0 : 1))
clicolor_force_true         FZF_FS_LS_CLICOLOR=1
deference                   FZF_FS_LS_SYMLINK=L
deference_commandline       FZF_FS_LS_SYMLINK=H
lc_collate_c                LC_COLLATE=C
lc_collate_lang             LC_COLLATE=LANG
opener_console_default      FZF_FS_OPENER_CONSOLE=FZF_FS_OPENER_CONSOLE_DEFAULT
opener_console_editor       FZF_FS_OPENER_CONSOLE=EDITOR
opener_console_pager        FZF_FS_OPENER_CONSOLE=PAGER
opener_default              FZF_FS_OPENER=FZF_FS_OPENER_DEFAULT
opener_editor               FZF_FS_OPENER=EDITOR
opener_interactive          FZF_FS_OPENER=$(command fzf \
                            --prompt="FZF_FS_OPENER " --print-query <<< "")
opener_pager                FZF_FS_OPENER=PAGER
os_interactive              FZF_FS_OS=$(command fzf \
                            --prompt="uname -s => " --print-query <<< "")
show_atime                  FZF_FS_LS_OPTS=u
show_ctime                  FZF_FS_LS_OPTS=c
show_hidden_false           FZF_FS_LS_HIDDEN=0
show_hidden_toggle          FZF_FS_LS_HIDDEN=$((FZF_FS_LS_HIDDEN ? 0 : 1))
show_hidden_true            FZF_FS_LS_HIDDEN=1
show_mtime                  FZF_FS_LS_OPTS=
sort_atime                  FZF_FS_LS_OPTS=ut
sort_basename               FZF_FS_LS_OPTS=
sort_ctime                  FZF_FS_LS_OPTS=it
sort_interactive            FZF_FS_SORT=$(command fzf \
                            --prompt="sort " --print-query <<< "")
                            The first column of ls in the browser is internally
                            the second column; the first column shows the inode
                            number like in ls -li. Do not sort ls output with
                            ansi code; first use clicolor_force_toggle
sort_mtime                  FZF_FS_LS_OPTS=t
sort_reverse_false          FZF_FS_LS_REVERSE=0
sort_reverse_toggle         FZF_FS_LS_REVERSE=$((FZF_FS_LS_REVERSE ? 0 : 1))
sort_reverse_true           FZF_FS_LS_REVERSE=1
sort_size                   FZF_FS_SORT=-k6,6n
sort_type                   FZF_FS_SORT=-k2
```

See also section [SCRIPTING](#scripting).

##### FLAGS

Some internal console commands can be used with own options to determine their process. Flags are always placed as first argument to the command and will be parsed before macro pattern substitution.

```
f               Execute process in background
k               Keep the process. Wait for a key press or spawn a new shell
                instance
t               Run process in a new terminal emulator window

Example: shell -tf locate . | fzf
```

You may configure your own flags in the file `env/flags.user`; use them in a function called `flags_func`.

##### MACROS

Macros are placeholder strings and used in internal commands to point to internal variables. Each occurrence of a macro will be replaced.

```
%b              ${FZF_FS_CONFIG_DIR}/env/browser_shortcuts.user
%c              ${FZF_FS_CONFIG_DIR}/env/console_shortcuts.user
%d              The path of the current working directory
%e              ${FZF_FS_CONFIG_DIR}/env/env.user
%f              ${FZF_FS_CONFIG_DIR}/env/flags.user
%m              ${FZF_FS_CONFIG_DIR}/env/macros.user
%s              The last directly selected file (or directory) entry

Example: shell -t fzf-fs %s
```

You may configure your own macros in the file `env/macros.user`.

##### SHORTCUTS

The browser pane lists files, and optionally shortcuts to have access to the console commands (configured in `env/browser_shortcuts.user`). When you run the console command without additional specification, you can browse all configured console commands in a second browser pane ("console pane"). The console pane contains only shortcuts, which have been set in `env/console_shortcuts.user`.

A console shortcut has the following syntax:

```
[<shortcut>] <console_file_name> <arg> ... <arg>n
```

And a browser shortcut this one:

```
_ [<shortcut>] <console_file_name> <arg> ... <arg>n
```

##### SCRIPTING

Console commands are stored in `console/` and will be sourced into fzf-fs; execution takes only place, when they are declared in a function called `console_func` or as value of the normal scalar variable `console`. For example:

```sh
% cat console/set/show_hidden_toggle
console="FZF_FS_LS_HIDDEN=$((FZF_FS_LS_HIDDEN ? 0 : 1))"

% cat console/set/lc_collate_c
console="LC_COLLATE=C"
```

or

```sh
% cat console/terminal
console_func ()
{
    ( command ${SHELL:-sh} -c ${TERMINAL} & )
}
```

In the global scope of `console_func` the following variables are available:

```
browser_file                The absolute path of the last selected directory
                            or file in the browser pane
browser_pwd                 The absolute path of the current working directory
                            in the browser pane
browser_pwd_inode           The inode number of browser_pwd
browser_pwd_inode_parent    The inode number of the parent directory of
                            browser_pwd
browser_root                Root of the file system. Usually "/"
browser_selection           The selected list entry in the browser pane
                            (ls or shortcut entry)
browser_selection_inode     The inode number of browser_file
```

If `console_func` has been executed via the "console pane", it is interactive. In that case, the integer variable `console_interactive` is not `0` and there are no positional parameters to the function available. `console_selection` points to the selected shortcut in the console pane; `console_file` is the absolute path of the console file in `console/`.

When the execution is not interactive, `console_file` is set, but `console_selection` is NULL. The postional parameters are the value of `${browser_selection##*\] }` (shortcut entry without name and brackets).

To write portable scripts, use the functions `__fzffs_util_echo`, `__fzffs_util_echoE` and `__fzffs_util_echon` from `fzf-fs`.

To work with flags and macros in your console command, use `__fzffs_util_parse_flags` and `__fzffs_util_parse_macros` (see `console/edit` for example). After `__fzffs_util_parse_flags` has been executed, you can use the variables `console_fork_background`, `console_keep` and `console_terminal` (see `console/shell` for example); after `__fzffs_util_parse_macros` the variable `console_args` is available.

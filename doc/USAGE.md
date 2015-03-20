.TH "fzf-fs" "1" "Fri Mar 20 04:08:58 CET 2015" "0.1.8" "USAGE"

##### USAGE

First have a look at [fzf](https://github.com/junegunn/fzf), if you are unfamiliar with its usage. Mainly, fzf(1) is a curses-based filter and finder for the command line. Think about the pager less(1) with optional fuzzy matching, extended-searching and (multi) selection methods to pick up and dump results to stdout. Both tools are fullscreen or one pane applications. Without the help of multiplexers, the embedding of tty emulators or scripting inside an editor environment, it's tricky to have different layouts and views etc. Unlike less(1), fzf(1) do currently not have the following example resources:

- configuration for keybindings
- ansi color support
- command line editing
- completion features in the input/query field
- methods to copy/dump the screen while in execution
- internal commands to change settings while in execution

But it doesn't matter. fzf(1) had not been invented to be pager. Although there are other [tools](https://gist.github.com/D630/e27b17f3da843f974c50#file-selection-driven-cli-apps-csv) similiar to fzf(1), I vote for it because of its speed (especially since it is has been rewritten in Go) and the develeopers careful work.

Sourcing/Execution
Environment
Flags
Macros
Commands

EDITOR
FZF_DEFAULT_COMMAND='command echo uups'
FZF_DEFAULT_OPTS
FZF_FS_DEFAULT_OPTS
FZF_FS_LS
FZF_FS_LS_HIDDEN
FZF_FS_LS_REVERSE
FZF_FS_OPENER
FZF_FS_SORT
FZF_FS_SYMLINK
LC_COLLATE
PAGER
TERMINAL

#### Version 0.2.3 (fzf >= 0.11.3 required)

fzf-fs is now a stupid configurable file browser/navigator that is structured in "modes" (console, normal, search) while using fzf's `bind` and `expect` options.

Main changes:
- modes
- keybindings now provided via bind and expect
- no installer script anymore
- removed compatibility of ksh/mksh. Support for: bash and zsh only
- use of submodule spath.sh
- commandline options -d and -e
- different local config files
- extensible (own modes, commands) and configurable (many environment variables on commandline or in config file; keybindings for most fzf executions)

#### Testing

A complete documentation will follow.

#### GIT

```
git clone -b 0.2.3 --single-branch --depth 1 --recursive -- https://github.com/d630/fzf-fs
```

#### Install

Put `./fzf-fs` and `./modules/spath.sh/spath.sh` on your PATH.

#### Usage

##### Invocation

```sh
. fzf-fs [options]

. fzf-fs -d [ . | .. | - | DIR | ]
. fzf-fs -e "SUBCOMMAND"

# examples

. fzf-fs -d /tmp
. fzf-fs -e "Fzf::Fs::C::Set search_mode"
. fzf-fs -e "Fzf::Fs::C::Set -i"
```

##### Subcommands

```
Chdir           Change directory
Child           Open the selection in normal and search mode. Calls Chdir or Open
EMapKey         Map key on fzf's execute() action
ExpectKey       Append key to expect variable
Edit            Open X in editor
GetKey          Opens a fzf "pane" to complete the keybinding
MapKey          Map key on one of fzf's actions
Open            Open X in opener
Page            Open X in pager
Parent          Go n directories up
PrintSettings   Print out current environment (interactively in console)
Quit            Quit fzf-fs
Set             Set settings with string values (interactively in console):
                console_color
                console_colorscheme_16
                console_colorscheme_bw
                console_colorscheme_dark
                console_colorscheme_light
                console_history
                console_hsize
                console_margin
                console_mode
                console_tabstop
                lc_collate
                lc_collate_c
                lc_collate_lang
                ls_format
                ls_reverse_false
                ls_reverse_true
                ls_show
                ls_show_atime
                ls_show_ctime
                ls_show_mtime
                ls_sort
                ls_sort_atime
                ls_sort_bname
                ls_sort_ctime
                ls_sort_mtime
                ls_sort_nothing
                ls_sort_size
                mode
                normal_color
                normal_colorscheme_16
                normal_colorscheme_bw
                normal_colorscheme_dark
                normal_colorscheme_light
                normal_margin
                normal_mode
                normal_tabstop
                search_case
                search_color
                search_colorscheme_16
                search_colorscheme_bw
                search_colorscheme_dark
                search_colorscheme_light
                search_history
                search_hsize
                search_margin
                search_mode
                search_tabstop
                search_tiebreak
Toggle          Toggle settings with integer values (interactively in console):
                console_black
                console_cycle
                console_hscroll
                console_inline
                console_mouse
                console_reverse
                console_tac
                ls_classify
                ls_color
                ls_dereference
                ls_dereference_cl
                ls_human
                ls_kibibytes
                ls_long
                ls_reverse
                ls_show_hidden
                ls_show_size
                ls_slash
                normal_black
                normal_cycle
                normal_hscroll
                normal_inline
                normal_mouse
                normal_reverse
                normal_tac
                search_black
                search_cycle
                search_exact
                search_extended
                search_hscroll
                search_inline
                search_mouse
                search_reverse
                search_sort
                search_tac
```

##### Utils functions

Used in Subcommands.

```
Fzf::Fs::U::Get::Args
Fzf::Fs::U::Parse::Line
Fzf::Fs::U::Set::Cursor
Fzf::Fs::U::Set::FName
Fzf::Fs::U::Set::Prompt
Fzf::Fs::U::Set::Pwd
Fzf::Fs::U::Spool
```

##### Command functions

```
__fzf_fs_ls
__fzf_fs_ls_color
__fzf_fs_editor
__fzf_fs_opener
__fzf_fs_pager
```

##### Default Keybindings

###### Console mode

Fzf default bindings, but:

```
ctrl-c  Normal Mode
ctrl-g  Normal Mode
ctrl-q  Quit
esc     Normal Mode
f1      GetKey f1
f11     Set console_colorscheme_16
f1C     Toggle console_cycle
f1H     Set console_history
f1S     Set console_hsize
f1T     Toggle console_tac
f1b     Toggle console_black
f1c     Set console_color
f1d     Set console_colorscheme_dark
f1g     Set console_margin
f1i     Toggle console_inline
f1l     Set console_colorscheme_light
f1m     Toggle console_mouse
f1r     Toggle console_reverse
f1s     Toggle console_hscroll
f1t     Set console_tabstop
f1w     Set console_colorscheme_bw
tab     query completition
```

###### Normal mode

Most keys will be ignored.

```
/       Search mode
:       Console mode
;       Search mode
C       GetKey C
C1      Set normal_colorscheme_16
CC      Set normal_color
Cb      Toggle normal_black
Cc      Toggle ls_color
Cd      Set normal_colorscheme_dark
Cl      Set normal_colorscheme_light
Ctrl-b  page-up
Ctrl-c  Quit
Ctrl-f  page-down
Ctrl-l  clear-screen
Ctrl-m  Child
Cw      Set normal_colorscheme_bw
E       Edit
N       Search mode
Z       GetKey Z
ZF      Toggle ls_classify
ZH      Toggle ls_dereference_cl
ZL      Toggle ls_dereference
ZM      Set ls_format
Za      Toggle ls_show_hidden
Zc      Set ls_show_ctime
Zh      Toggle ls_human
Zk      Toggle ls_kibibytes
Zl      Toggle ls_long
Zm      Set ls_show_mtime
Zp      Toggle ls_slash
Zr      Toggle ls_reverse
Zs      Toggle ls_show_size
Zu      Set ls_show_atime
down    down
enter   Child
g       GetKey g
g-      Chdir $OLDPWD
g/      Chdir /
g1      Parent 1
g2      Parent 2
gL      Chdir /var/log
gM      Chdir /mnt
gd      Chdir /dev
ge      Chdir /etc
gh      Chdir $HOME
gl      Chdir /usr/lib
gm      Chdir /media
go      Chdir /opt
gr      Chdir /
gs      Chdir /srv
gt      Chdir /tmp
gu      Chdir /usr
gv      Chdir /var
g~      Chdir $HOME
h       Parent 1
i       Page
j       down
k       up
l       Child
left    Parent 1
n       Search mode
o       GetKey o
oA      Set ls_sort_atime ls_reverse_false
oB      Set ls_sort_bname ls_reverse_false
oC      Set ls_sort_ctime ls_reverse_false
oM      Set ls_sort_mtime ls_reverse_false
oS      Set ls_sort_size ls_reverse_false
oa      Set ls_sort_atime ls_reverse_true
ob      Set ls_sort_bname ls_reverse_true
oc      Set ls_sort_ctime ls_reverse_true
om      Set ls_sort_mtime ls_reverse_true
on      Set ls_sort_nothing
os      Set ls_sort_size ls_reverse_true
pgdn    page-down
pgup    page-up
q       Quit
right   Child
up      up
z       GetKey z
z1      Set lc_collate_c
z2      Set lc_collate_lang
zT      Toggle normal_tac
zc      Toggle normal_cycle
zg      Set normal_margin
zi      Toggle normal_inline
zm      Toggle normal_mouse
zr      Toggle normal_reverse
zs      Toggle normal_hscroll
zt      Set normal_tabstop
```

###### Search mode

Fzf default bindings, but:

```
alt-e   Edit
alt-h   Parent 1
alt-i   Page
alt-l   Child
ctrl-c  Normal mode
ctrl-g  Normal mode
ctrl-m  Child
ctrl-q  Quit
enter   Child
esc     Normal mode
f1      GetKey f1
f11     Set search_colorscheme_16
f1B     Set search_tiebreak
f1C     Toggle search_cycle
f1E     Toggle search_extended
f1H     Set search_history
f1S     Set search_hsize
f1T     Toggle search_tac
f1a     Set search_case
f1b     Toggle search_black
f1c     Set search_color
f1d     Set search_colorscheme_dark
f1e     Toggle search_exact
f1g     Set search_margin
f1i     Toggle search_inline
f1l     Set search_colorscheme_light
f1m     Toggle search_mouse
f1o     Toggle search_sort
f1r     Toggle search_reverse
f1s     Toggle search_hscroll
f1t     Set search_tabstop
f1w     Set search_colorscheme_bw
```

###### Set and Toggle command in console mode

Fzf default bindings, but:

```
btab        toggle-out
ctrl-i      toggle-in
ctrl-r      toggle-sort
f1          select-all
f2          deselect-all
shift-tab   toggle-out
space       toggle
tab         toggle-in
v           toggle-all
```

##### Environment

Specify FZF_FS_CONF_DIR on the commandline, otherwise:
`${FZF_FS_CONF_DIR:-${XDG_CONFIG_HOME:-${HOME}/.config}/fzf-fs.d}`.

```sh
builtin typeset -x \
        FZF_DEFAULT_COMMAND= \
        FZF_DEFAULT_OPTS= \
        FZF_FS_MODE=${FZF_FS_MODE:-normal} \
        FZF_FS_OS= \
        FZF_FS_SPOOL_FILE="${FZF_FS_SPOOL_FILE:-/tmp/fzf-fs-${USER}/fzf-fs.$$}" \
        LC_COLLATE_OLD=$LC_COLLATE \
        LC_COLLATE=C \
        _cursor_off="$(command tput civis || command tput vi)" \
        _cursor_on="$(command tput cnorm || command tput ve)" \
        _ls_default_opts= \
        _prompt=;

builtin typeset \
        bind \
        expect;

builtin typeset -i -x FZF_FS_SHOW_CURSOR=$FZF_FS_SHOW_CURSOR

builtin typeset -i -x \
        FZF_FS_LS_COLOR=$FZF_FS_LS_COLOR \
        FZF_FS_LS_F=$FZF_FS_LS_F \
        FZF_FS_LS_H=$FZF_FS_LS_H \
        FZF_FS_LS_HIDDEN=$FZF_FS_LS_HIDDEN \
        FZF_FS_LS_L=$FZF_FS_LS_L \
        FZF_FS_LS_LONG=$FZF_FS_LS_LONG \
        FZF_FS_LS_h=$FZF_FS_LS_h \
        FZF_FS_LS_k=$FZF_FS_LS_k \
        FZF_FS_LS_p=$FZF_FS_LS_p \
        FZF_FS_LS_r=$FZF_FS_LS_r \
        FZF_FS_LS_s=$FZF_FS_LS_s;
builtin typeset -x \
        FZF_FS_LS_FORMAT=${FZF_FS_LS_FORMAT:-l} \
        FZF_FS_LS_SORT=${FZF_FS_LS_SORT:-nothing} \
        FZF_FS_LS_TIME=${FZF_FS_LS_TIME:-mtime};

builtin typeset -i -x \
        FZF_FS_CONSOLE_BLACK=$FZF_FS_CONSOLE_BLACK \
        FZF_FS_CONSOLE_CYCLE=$FZF_FS_CONSOLE_CYCLE \
        FZF_FS_CONSOLE_HSCROLL=$FZF_FS_CONSOLE_HSCROLL \
        FZF_FS_CONSOLE_INLINE=$FZF_FS_CONSOLE_INLINE \
        FZF_FS_CONSOLE_MOUSE=$FZF_FS_CONSOLE_MOUSE \
        FZF_FS_CONSOLE_REVERSE=$FZF_FS_CONSOLE_REVERSE \
        FZF_FS_CONSOLE_TAC=$FZF_FS_CONSOLE_TAC \
        FZF_FS_NORMAL_BLACK=$FZF_FS_NORMAL_BLACK \
        FZF_FS_NORMAL_CYCLE=$FZF_FS_NORMAL_CYCLE \
        FZF_FS_NORMAL_HSCROLL=$FZF_FS_NORMAL_HSCROLL \
        FZF_FS_NORMAL_INLINE=$FZF_FS_NORMAL_INLINE \
        FZF_FS_NORMAL_MOUSE=$FZF_FS_NORMAL_MOUSE \
        FZF_FS_NORMAL_REVERSE=${FZF_FS_NORMAL_REVERSE:-1} \
        FZF_FS_NORMAL_TAC=$FZF_FS_NORMAL_TAC \
        FZF_FS_SEARCH_BLACK=$FZF_FS_SEARCH_BLACK \
        FZF_FS_SEARCH_CYCLE=$FZF_FS_SEARCH_CYCLE \
        FZF_FS_SEARCH_EXACT=$FZF_FS_SEARCH_EXACT \
        FZF_FS_SEARCH_EXTENDED=${FZF_FS_SEARCH_EXTENDED:-1} \
        FZF_FS_SEARCH_HSCROLL=$FZF_FS_SEARCH_HSCROLL \
        FZF_FS_SEARCH_INLINE=$FZF_FS_SEARCH_INLINE \
        FZF_FS_SEARCH_MOUSE=$FZF_FS_SEARCH_MOUSE \
        FZF_FS_SEARCH_REVERSE=$FZF_FS_SEARCH_REVERSE \
        FZF_FS_SEARCH_SORT=${FZF_FS_SEARCH_SORT:-1} \
        FZF_FS_SEARCH_TAC=$FZF_FS_SEARCH_TAC \
        FZF_FS_SET_BLACK=$FZF_FS_SET_BLACK \
        FZF_FS_SET_CYCLE=$FZF_FS_SET_CYCLE \
        FZF_FS_SET_EXACT=$FZF_FS_SET_EXACT \
        FZF_FS_SET_EXTENDED=${FZF_FS_SET_EXTENDED:-1} \
        FZF_FS_SET_HSCROLL=$FZF_FS_SET_HSCROLL \
        FZF_FS_SET_INLINE=$FZF_FS_SET_INLINE \
        FZF_FS_SET_MOUSE=$FZF_FS_SET_MOUSE \
        FZF_FS_SET_REVERSE=$FZF_FS_SET_REVERSE \
        FZF_FS_SET_SORT=${FZF_FS_SET_SORT:-1} \
        FZF_FS_SET_TAC=$FZF_FS_SET_TAC \
        FZF_FS_TOGGLE_BLACK=$FZF_FS_TOGGLE_BLACK \
        FZF_FS_TOGGLE_CYCLE=$FZF_FS_TOGGLE_CYCLE \
        FZF_FS_TOGGLE_EXACT=$FZF_FS_TOGGLE_EXACT \
        FZF_FS_TOGGLE_EXTENDED=${FZF_FS_TOGGLE_EXTENDED:-1} \
        FZF_FS_TOGGLE_HSCROLL=$FZF_FS_TOGGLE_HSCROLL \
        FZF_FS_TOGGLE_INLINE=$FZF_FS_TOGGLE_INLINE \
        FZF_FS_TOGGLE_MOUSE=$FZF_FS_TOGGLE_MOUSE \
        FZF_FS_TOGGLE_REVERSE=$FZF_FS_TOGGLE_REVERSE \
        FZF_FS_TOGGLE_SORT=${FZF_FS_TOGGLE_SORT:-1} \
        FZF_FS_TOGGLE_TAC=$FZF_FS_TOGGLE_TAC;

builtin typeset -x \
        FZF_FS_CONSOLE_COLOR=${FZF_FS_CONSOLE_COLOR:-bw} \
        FZF_FS_CONSOLE_HISTORY=$FZF_FS_CONSOLE_HISTORY \
        FZF_FS_CONSOLE_HSIZE=${FZF_FS_CONSOLE_HSIZE:-1000} \
        FZF_FS_CONSOLE_MARGIN=$FZF_FS_CONSOLE_MARGIN \
        FZF_FS_CONSOLE_TABSTOP=${FZF_FS_CONSOLE_TABSTOP:-8} \
        FZF_FS_NORMAL_COLOR=${FZF_FS_NORMAL_COLOR:-bw} \
        FZF_FS_NORMAL_MARGIN=$FZF_FS_NORMAL_MARGIN \
        FZF_FS_NORMAL_TABSTOP=${FZF_FS_NORMAL_TABSTOP:-8} \
        FZF_FS_SEARCH_CASE=${FZF_FS_SEARCH_CASE:-smart} \
        FZF_FS_SEARCH_COLOR=${FZF_FS_SEARCH_COLOR:-bw} \
        FZF_FS_SEARCH_HISTORY=$FZF_FS_SEARCH_HISTORY \
        FZF_FS_SEARCH_HSIZE=${FZF_FS_SEARCH_HSIZE:-1000} \
        FZF_FS_SEARCH_MARGIN=$FZF_FS_SEARCH_MARGIN \
        FZF_FS_SEARCH_TABSTOP=${FZF_FS_SEARCH_TABSTOP:-8} \
        FZF_FS_SEARCH_TIEBREAK=${FZF_FS_SEARCH_TIEBREAK:-"length,index"} \
        FZF_FS_SET_CASE=${FZF_FS_SET_CASE:-smart} \
        FZF_FS_SET_COLOR=${FZF_FS_SET_COLOR:-bw} \
        FZF_FS_SET_MARGIN=$FZF_FS_SET_MARGIN \
        FZF_FS_SET_TABSTOP=${FZF_FS_SET_TABSTOP:-8} \
        FZF_FS_SET_TIEBREAK=${FZF_FS_SET_TIEBREAK:-"length,index"}
        FZF_FS_TOGGLE_CASE=${FZF_FS_TOGGLE_CASE:-smart} \
        FZF_FS_TOGGLE_COLOR=${FZF_FS_TOGGLE_COLOR:-bw} \
        FZF_FS_TOGGLE_MARGIN=$FZF_FS_TOGGLE_MARGIN \
        FZF_FS_TOGGLE_TABSTOP=${FZF_FS_TOGGLE_TABSTOP:-8} \
        FZF_FS_TOGGLE_TIEBREAK=${FZF_FS_TOGGLE_TIEBREAK:-"length,index"};

builtin typeset -i -x \
        FZF_FS_NORMALK_BLACK=$FZF_FS_NORMALK_BLACK \
        FZF_FS_NORMALK_CYCLE=$FZF_FS_NORMALK_CYCLE \
        FZF_FS_NORMALK_HSCROLL=$FZF_FS_NORMALK_HSCROLL \
        FZF_FS_NORMALK_INLINE=$FZF_FS_NORMALK_INLINE \
        FZF_FS_NORMALK_MOUSE=$FZF_FS_NORMALK_MOUSE \
        FZF_FS_NORMALK_REVERSE=${FZF_FS_NORMALK_REVERSE:-1} \
        FZF_FS_NORMALK_TAC=$FZF_FS_NORMALK_TAC;
builtin typeset -x \
        FZF_FS_NORMALK_COLOR=${FZF_FS_NORMALK_COLOR:-bw} \
        FZF_FS_NORMALK_MARGIN=$FZF_FS_NORMALK_MARGIN \
        FZF_FS_NORMALK_TABSTOP=${FZF_FS_NORMALK_TABSTOP:-8};

builtin typeset -i -x \
        FZF_FS_SEARCHK_BLACK=$FZF_FS_SEARCHK_BLACK \
        FZF_FS_SEARCHK_CYCLE=$FZF_FS_SEARCHK_CYCLE \
        FZF_FS_SEARCHK_HSCROLL=$FZF_FS_SEARCHK_HSCROLL \
        FZF_FS_SEARCHK_INLINE=$FZF_FS_SEARCHK_INLINE \
        FZF_FS_SEARCHK_MOUSE=$FZF_FS_SEARCHK_MOUSE \
        FZF_FS_SEARCHK_REVERSE=${FZF_FS_SEARCHK_REVERSE:-1} \
        FZF_FS_SEARCHK_TAC=$FZF_FS_SEARCHK_TAC;
builtin typeset -x \
        FZF_FS_SEARCHK_COLOR=${FZF_FS_SEARCHK_COLOR:-bw} \
        FZF_FS_SEARCHK_MARGIN=$FZF_FS_SEARCHK_MARGIN \
        FZF_FS_SEARCHK_TABSTOP=${FZF_FS_SEARCHK_TABSTOP:-8};

builtin typeset -i -x \
        FZF_FS_CONSOLEK_BLACK=$FZF_FS_CONSOLEK_BLACK \
        FZF_FS_CONSOLEK_CYCLE=$FZF_FS_CONSOLEK_CYCLE \
        FZF_FS_CONSOLEK_HSCROLL=$FZF_FS_CONSOLEK_HSCROLL \
        FZF_FS_CONSOLEK_INLINE=$FZF_FS_CONSOLEK_INLINE \
        FZF_FS_CONSOLEK_MOUSE=$FZF_FS_CONSOLEK_MOUSE \
        FZF_FS_CONSOLEK_REVERSE=${FZF_FS_CONSOLEK_REVERSE:-1} \
        FZF_FS_CONSOLEK_TAC=$FZF_FS_CONSOLEK_TAC;
builtin typeset -x \
        FZF_FS_CONSOLEK_COLOR=${FZF_FS_CONSOLEK_COLOR:-bw} \
        FZF_FS_CONSOLEK_MARGIN=$FZF_FS_CONSOLEK_MARGIN \
        FZF_FS_CONSOLEK_TABSTOP=${FZF_FS_CONSOLEK_TABSTOP:-8};
```

##### TO DO

- commands: shell, open_with and terminal (all with flags); help and version
- macros via macro.sh
- provide searching in GetKey command
- commandline option to use fzf-curr-position
- give more settings for Set and Toggle (all environment variable)
- update docs
- better handling of the spool file

##### Playlist

[Neu! - Hero](https://www.youtube.com/watch?v=owA7mW8S5Fo)
[The Sound - I Can't Escape Myself ](https://www.youtube.com/watch?v=8Ad2ujW5Sl8)
[Bush Tetras - Too Many Creeps](https://www.youtube.com/watch?v=PERvoP9YuM4)
[The Au Pairs - Headache for Michelle](https://www.youtube.com/watch?v=-JJuEDrxJ-0)
[Southern Death Cult - Moya](https://www.youtube.com/watch?v=kuuGxiuRvm8)
[The Slits - I Heard It Through The Grapevine](https://www.youtube.com/watch?v=pSq3-lE377Q)
[Teenage, Jesus and the Jerks - Orphans](https://www.youtube.com/watch?v=pQHc9NFPxdw)
[Mission of Burma - Trem Two](https://www.youtube.com/watch?v=BUZ8_TAdjg8)
[The Raincoats - In Love](https://www.youtube.com/watch?v=3r2ZZC49IAw)
[Dinosaur Jr. - Little Fury Things](https://www.youtube.com/watch?v=4WAFdBU88bg)
[Desmond Dekker - 007 (Shanty Town)](https://www.youtube.com/watch?v=ZqgWuMcHc3g)
[David Bowie - Five Years](https://www.youtube.com/watch?v=5-ceR9az3dk)
[Mars - 3e](https://www.youtube.com/watch?v=-ReyhyGzlt4)
[Fugazi - Waiting Room](https://www.youtube.com/watch?v=cMOAXm94VWo)
[Hüsker Dü - Turn On the News](https://www.youtube.com/watch?v=qkmPS-VTdic)
[The Raincoats - Lola](https://www.youtube.com/watch?v=mkBk9z6UfRY)


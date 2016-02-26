#### Version 0.2.3 (fzf >= 0.11.3 required)

fzf-fs is now a stupid configurable file browser/navigator that is structured in "modes" (console, normal, search) while using fzf's `bind` and `expect` options.

Main changes:
- modes
- keybindings now provided via bind and expect
- no installer script anymore
- removed compatibility of ksh/mksh and zsh. Support for: bash only (with assoc. arrays, mapfile and namerefs)
- use of submodule spath.sh
- commandline options -d and -e
- removed macros
- no use via source anymore
- extensible and configurable

#### Testing

A complete documentation will follow. Fzf-fs works best in terminals with disabled "alternate screen" (tput [sr]mcup).

#### GIT

```
git clone -b 0.2.3 --single-branch --depth 1 --recursive -- https://github.com/d630/fzf-fs
```

#### Install

Put `./bin/fzf-fs` and `./modules/spath.sh/spath.sh` on your PATH.

#### Usage

##### Invocation

```sh
fzf-fs [options]

fzf-fs -d [ . | .. | - | DIR | ]
fzf-fs -e "SUBCOMMAND"

# examples

fzf-fs
fzf-fs -d /tmp
fzf-fs -e "Fzf::Fs::C::Set search.mode"
fzf-fs -e "Fzf::Fs::C::Set -i"
```

##### Subcommands

```
BindKey
Chdir
Child
EBindKey
Edit
ExpectKey
GetKey
LegendKey
MapKey
Open
Page
Parent
Quit
Set
    console.history
    console.history.size
    console.margin
    console.mode
    console.tabstop
    console.theme
    console.theme.16
    console.theme.bw
    console.theme.dark
    console.theme.light
    consolek.margin
    consolek.tabstop
    consolek.theme
    consolek.theme.16
    consolek.theme.bw
    consolek.theme.dark
    consolek.theme.light
    lc.collate
    lc.collate.c
    lc.collate.lang
    ls.lformat
    ls.r
    ls.sort
    ls.sort.atime
    ls.sort.bname
    ls.sort.ctime
    ls.sort.mtime
    ls.sort.nothing
    ls.sort.size
    ls.time
    ls.time.atime
    ls.time.ctime
    ls.time.mtime
    mode
    normal.margin
    normal.mode
    normal.tabstop
    normal.theme
    normal.theme.16
    normal.theme.bw
    normal.theme.dark
    normal.theme.light
    normalk.margin
    normalk.tabstop
    normalk.theme
    normalk.theme.16
    normalk.theme.bw
    normalk.theme.dark
    normalk.theme.light
    os
    search.case
    search.criteria
    search.history
    search.history.size
    search.margin
    search.mode
    search.tabstop
    search.theme
    search.theme.16
    search.theme.bw
    search.theme.dark
    search.theme.light
    searchk.margin
    searchk.tabstop
    searchk.theme
    searchk.theme.16
    searchk.theme.bw
    searchk.theme.dark
    searchk.theme.light
    set.case
    set.criteria
    set.margin
    set.tabstop
    set.theme
    set.theme.16
    set.theme.bw
    set.theme.dark
    set.theme.light
    tog.case
    tog.criteria
    tog.margin
    tog.tabstop
    tog.theme
    tog.theme.16
    tog.theme.bw
    tog.theme.dark
    tog.theme.light
Shell
Toggle
    consolek.black
    consolek.cycle
    consolek.hscroll
    consolek.inline_info
    consolek.mouse
    consolek.reverse
    consolek.tac
    console.black
    console.cycle
    console.hscroll
    console.inline_info
    console.mouse
    console.reverse
    console.tac
    cursor
    ls.F
    ls.H
    ls.L
    ls.color
    ls.h
    ls.hidden
    ls.k
    ls.long
    ls.p
    ls.r
    ls.s
    normalk.black
    normalk.cycle
    normalk.hscroll
    normalk.inline_info
    normalk.mouse
    normalk.reverse
    normalk.tac
    normal.black
    normal.cycle
    normal.hscroll
    normal.inline_info
    normal.mouse
    normal.reverse
    normal.tac
    searchk.black
    searchk.cycle
    searchk.hscroll
    searchk.inline_info
    searchk.mouse
    searchk.reverse
    searchk.tac
    search.black
    search.cycle
    search.extended
    search.fuzzy
    search.hscroll
    search.inline_info
    search.mouse
    search.reverse
    search.sort
    search.tac
    set.black
    set.cycle
    set.extended
    set.fuzzy
    set.hscroll
    set.inline_info
    set.mouse
    set.reverse
    set.sort
    set.tac
    tog.black
    tog.cycle
    tog.extended
    tog.fuzzy
    tog.hscroll
    tog.inline_info
    tog.mouse
    tog.reverse
    tog.sort
    tog.tac
```

##### Utils functions

Used in Subcommands.

```
U::CopyFunc
U::Get::FName
U::Parse::Args
U::Set::Cursor
U::Set::Prompt
U::Set::Pwd
U::Test::Interactive
```

##### Command functions

```
Fzf::Fs::C::Editor
Fzf::Fs::C::Ls
Fzf::Fs::C::LsColor
Fzf::Fs::C::Opener
Fzf::Fs::C::Pager
Fzf::Fs::C::Sh
```

##### Default Keybindings

```sh
FzfFsBinds+=(
        [console.bind]="f4:execute(</dev/tty man fzf >/dev/tty),f3:execute(</dev/tty man fzf >/dev/tty),"
        [console.complete]="ctrl-i"
        [console.ctrl-c]="Fzf::Fs::C::Set normal.mode"
        [console.ctrl-g]="Fzf::Fs::C::Set normal.mode"
        [console.ctrl-q]="Fzf::Fs::C::Quit"
        [console.esc]="Fzf::Fs::C::Set normal.mode"
        [console.expect]='ctrl-c,ctrl-g,ctrl-i,ctrl-q,esc,f1,'
        [console.f1]="Fzf::Fs::C::GetKey f1"
        [consolek.f1.1]="Fzf::Fs::C::Set console.theme.16"
        [consolek.f1.C]="Fzf::Fs::C::Toggle console.cycle"
        [consolek.f1.H]="Fzf::Fs::C::Set -i console.history"
        [consolek.f1.S]="Fzf::Fs::C::Set -i console.history.size"
        [consolek.f1.T]="Fzf::Fs::C::Set console.tac"
        [consolek.f1.b]="Fzf::Fs::C::Toggle console.black"
        [consolek.f1.bind]="enter:ignore,f3:execute(</dev/tty man fzf >/dev/tty),f4:execute(</dev/tty man ls >/dev/tty),"
        [consolek.f1.c]="Fzf::Fs::C::Set -i console.theme"
        [consolek.f1.d]="Fzf::Fs::C::Set console.theme.dark"
        [consolek.f1.expect]="1,C,H,S,T,b,c,d,g,i,l,m,o,r,s,t,w,"
        [consolek.f1.g]="Fzf::Fs::C::Set -i console.margin"
        [consolek.f1.i]="Fzf::Fs::C::Toggle console.inline_info"
        [consolek.f1.l]="Fzf::Fs::C::Set console.theme.light"
        [consolek.f1.legend]=$'1 Set console.theme.16\nC Toggle console.cycle\nH Set console.history\nS Set console.history.size\nT Toggle console.tac\nb Toggle console.black\nc Set console.theme\nd Set console.theme.dark\ng Set console.margin\ni Toggle console.inline_info\nl Set console.theme.light\nm Toggle console.mouse\nr Toggle console.reverse\ns Toggle console.hscroll\nt Set console.tabstop\nw Set console.theme.bw'
        [consolek.f1.m]="Fzf::Fs::C::Toggle console.mouse"
        [consolek.f1.o]="Fzf::Fs::C::Toggle console.sort"
        [consolek.f1.r]="Fzf::Fs::C::Toggle console.reverse"
        [consolek.f1.s]="Fzf::Fs::C::Toggle console.hscroll"
        [consolek.f1.t]="Fzf::Fs::C::Set -i console.tabstop"
        [consolek.f1.w]="Fzf::Fs::C::Set console.theme.bw"
        [normal./]="Fzf::Fs::C::Set search.mode"
        [normal.:]="Fzf::Fs::C::Set console.mode"
        [normal.;]="Fzf::Fs::C::Set console.mode"
        [normal.C]="Fzf::Fs::C::GetKey C"
        [normal.E]="Fzf::Fs::C::Edit {}"
        [normal.N]="Fzf::Fs::C::Set search.mode"
        [normal.S]="Fzf::Fs::C::Shell"
        [normal.T]="Fzf::Fs::C::Shell -ft exec "$SHELL""
        [normal.Z]="Fzf::Fs::C::GetKey Z"
        [normal.bind]="f4:execute(</dev/tty man fzf >/dev/tty),f3:execute(</dev/tty man fzf >/dev/tty),ctrl-b:page-up,ctrl-f:page-down,ctrl-l:clear-screen,down:down,j:down,k:up,pgdn:page-down,pgup:page-up,up:up,alt-b:ignore,alt-bspace:ignore,alt-d:ignore,alt-f:ignore,btab:ignore,ctrl-a:ignore,ctrl-d:ignore,ctrl-e:ignore,ctrl-g:ignore,ctrl-h:ignore,ctrl-i:ignore,ctrl-j:ignore,ctrl-k:ignore,ctrl-n:ignore,ctrl-p:ignore,ctrl-q:ignore,ctrl-u:ignore,ctrl-w:ignore,ctrl-y:ignore,del:ignore,end:ignore,esc:ignore,home:ignore,shift-left:ignore,shift-right:ignore,tab:ignore,"
        [normal.c]="Fzf::Fs::C::GetKey c"
        [normal.ctrl-c]="Fzf::Fs::C::Quit"
        [normal.ctrl-m]="Fzf::Fs::C::Child {}"
        [normal.enter]="Fzf::Fs::C::Child {}"
        [normal.expect]='/,:,;,C,E,N,S,T,Z,c,ctrl-c,ctrl-m,enter,g,h,i,l,left,n,o,q,r,right,z,'
        [normal.g]="Fzf::Fs::C::GetKey g"
        [normal.h]="Fzf::Fs::C::Parent 1"
        [normal.i]="Fzf::Fs::C::Page {}"
        [normal.l]="Fzf::Fs::C::Child {}"
        [normal.left]="Fzf::Fs::C::Parent 1"
        [normal.n]="Fzf::Fs::C::Set search.mode"
        [normal.o]="Fzf::Fs::C::GetKey o"
        [normal.q]="Fzf::Fs::C::Quit"
        [normal.r]="Fzf::Fs::C::GetKey r {}"
        [normal.right]="Fzf::Fs::C::Child {}"
        [normal.z]="Fzf::Fs::C::GetKey z"
        [normalk.C.1]="Fzf::Fs::C::Set normal.theme.16"
        [normalk.C.C]="Fzf::Fs::C::Set -i normal.theme"
        [normalk.C.b]="Fzf::Fs::C::Toggle normal.black"
        [normalk.C.bind]="enter:ignore,f3:execute(</dev/tty man fzf >/dev/tty),f4:execute(</dev/tty man ls >/dev/tty),"
        [normalk.C.c]="Fzf::Fs::C::Toggle ls.color"
        [normalk.C.d]="Fzf::Fs::C::Set normal.theme.dark"
        [normalk.C.expect]="1,C,b,c,d,l,w,"
        [normalk.C.l]="Fzf::Fs::C::Set normal.theme.light"
        [normalk.C.legend]=$'1 Set normal.theme.16\nC Set normal.color\nb Toggle normal.black\nc Toggle ls.color\nd Set normal.theme.dark\nl Set normal.theme.light\nw Set normal.theme.bw'
        [normalk.C.w]="Fzf::Fs::C::Set normal.theme.bw"
        [normalk.Z.F]="Fzf::Fs::C::Toggle ls.F"
        [normalk.Z.H]="Fzf::Fs::C::Toggle ls.H"
        [normalk.Z.L]="Fzf::Fs::C::Toggle ls.L"
        [normalk.Z.M]="Fzf::Fs::C::Set -i ls.lformat"
        [normalk.Z.a]="Fzf::Fs::C::Toggle ls.hidden"
        [normalk.Z.bind]="enter:ignore,f3:execute(</dev/tty man fzf >/dev/tty),f4:execute(</dev/tty man ls >/dev/tty),"
        [normalk.Z.c]="Fzf::Fs::C::Set ls.time.ctime"
        [normalk.Z.expect]="F,H,L,M,a,c,h,k,l,m,p,r,s,u,"
        [normalk.Z.h]="Fzf::Fs::C::Toggle ls.h"
        [normalk.Z.k]="Fzf::Fs::C::Toggle ls.k"
        [normalk.Z.l]="Fzf::Fs::C::Toggle ls.long"
        [normalk.Z.legend]=$'F Toggle ls.F\nH Toggle ls.H\nL Toggle ls.L\nM Set ls.lformat\na Toggle ls.hidden\nc Set ls.time.ctime\nh Toggle ls.h\nk Toggle ls.k\nl Toggle ls.long\nm Set ls.time.mtime\np Toggle ls.p\nr Toggle ls.r\ns Toggle ls.s\nu Set ls.time.atime'
        [normalk.Z.m]="Fzf::Fs::C::Set ls.time.m"
        [normalk.Z.p]="Fzf::Fs::C::Toggle ls.p"
        [normalk.Z.r]="Fzf::Fs::C::Toggle ls.r"
        [normalk.Z.s]="Fzf::Fs::C::Toggle ls.time.size"
        [normalk.Z.u]="Fzf::Fs::C::Set ls.time.atime"
        [normalk.c.bind]="enter:ignore,f3:execute(</dev/tty man fzf >/dev/tty),f4:execute(</dev/tty man ls >/dev/tty),"
        [normalk.c.d]="Fzf::Fs::C::Chdir"
        [normalk.c.expect]="d,p,"
        [normalk.c.legend]=$'d Chdir\np parent'
        [normalk.c.p]="Fzf::Fs::C::Parent"
        [normalk.g.-]='Fzf::Fs::C::Chdir "$OLDPWD"'
        [normalk.g./]="Fzf::Fs::C::Chdir /"
        [normalk.g.1]="Fzf::Fs::C::Parent 1"
        [normalk.g.2]="Fzf::Fs::C::Parent 2"
        [normalk.g.L]="Fzf::Fs::C::Chdir /var/log"
        [normalk.g.M]="Fzf::Fs::C::Chdir /mnt"
        [normalk.g.bind]="enter:ignore,f3:execute(</dev/tty man fzf >/dev/tty),f4:execute(</dev/tty man ls >/dev/tty),"
        [normalk.g.d]="Fzf::Fs::C::Chdir /dev"
        [normalk.g.e]="Fzf::Fs::C::Chdir /etc"
        [normalk.g.expect]="-,/,L,M,d,e,h,l,m,o,r,s,t,u,v,~,1,2,"
        [normalk.g.h]='Fzf::Fs::C::Chdir "$HOME"'
        [normalk.g.l]="Fzf::Fs::C::Cddir /usr/lib"
        [normalk.g.legend]=$'- Chdir $OLDPWD\n/ Chdir /\n1 Parent 1\n2 Parent 2\nL Chdir /var/log\nM Chdir /mnt\nd Chdir /dev\ne Chdir /etc\nh Chdir $HOME\nl Chdir /usr/lib\nm Chdir /media\no Chdir /opt\nr Chdir /\ns Chdir /srv\nt Chdir /tmp\nu Chdir /usr\nv Chdir /var\n~ Chdir $HOME'
        [normalk.g.m]="Fzf::Fs::C::Chdir /media"
        [normalk.g.o]="Fzf::Fs::C::Chdir /opt"
        [normalk.g.r]="Fzf::Fs::C::Chdir /"
        [normalk.g.s]="Fzf::Fs::C::Chdir /srv"
        [normalk.g.t]="Fzf::Fs::C::Chdir /tmp"
        [normalk.g.u]="Fzf::Fs::C::Chdir /usr"
        [normalk.g.v]="Fzf::Fs::C::Chdir /var"
        [normalk.g.~]='Fzf::Fs::C::Chdir "$HOME"'
        [normalk.o.A]="Fzf::Fs::C::Set ls.sort.atime;Fzf::Fs::C::Set ls.r.false"
        [normalk.o.B]="Fzf::Fs::C::Set ls.sort.bname;Fzf::Fs::C::Set ls.r.false"
        [normalk.o.C]="Fzf::Fs::C::Set ls.sort.ctime;Fzf::Fs::C::Set ls.r.false"
        [normalk.o.M]="Fzf::Fs::C::Set ls.sort.mtime;Fzf::Fs::C::Set ls.r.false"
        [normalk.o.S]="Fzf::Fs::C::Set ls.sort.size;Fzf::Fs::C::Set ls.r.false"
        [normalk.o.a]="Fzf::Fs::C::Set ls.sort.atime;Fzf::Fs::C::Set ls.r.true"
        [normalk.o.b]="Fzf::Fs::C::Set ls.sort.bname;Fzf::Fs::C::Set ls.r.true"
        [normalk.o.bind]="enter:ignore,f3:execute(</dev/tty man fzf >/dev/tty),f4:execute(</dev/tty man ls >/dev/tty),"
        [normalk.o.c]="Fzf::Fs::C::Set ls.sort.ctime;Fzf::Fs::C::Set ls.r.true"
        [normalk.o.expect]="A,B,C,M,S,a,b,c,m,n,s,"
        [normalk.o.legend]=$'A Set ls.sort.atime ls.r.false\nB Set ls.sort.bname ls.r.false\nC Set ls.sort.ctime ls.r.false\nM Set ls.sort.mtime ls.r.false\nS Set ls.sort.size ls.r.false\na Set ls.sort.atime ls.r.true\nb Set ls.sort.bname ls.r.true\nc Set ls.sort.ctime ls.r.true\nm Set ls.sort.mtime ls.r.true\nn Set ls.sort.nothing\ns Set ls.sort.size ls.r.true'
        [normalk.o.m]="Fzf::Fs::C::Set ls.sort.mtime;Fzf::Fs::C::Set ls.r.true"
        [normalk.o.n]="Fzf::Fs::C::Set ls.sort.nothing"
        [normalk.o.s]="Fzf::Fs::C::Set ls.sort.size;Fzf::Fs::C::Set ls.r.true"
        [normalk.r.bind]="enter:ignore,f3:execute(</dev/tty man fzf >/dev/tty),f4:execute(</dev/tty man ls >/dev/tty),"
        [normalk.r.e]="Fzf::Fs::C::Edit {}"
        [normalk.r.expect]="e,o,p,"
        [normalk.r.legend]=$'e Edit {}\np Page {}\no Open {}'
        [normalk.r.o]="Fzf::Fs::C::Open {}"
        [normalk.r.p]="Fzf::Fs::C::Page {}"
        [normalk.z.1]="Fzf::Fs::C::Set lc.collate.c"
        [normalk.z.2]="Fzf::Fs::C::Set lc.collate.lang"
        [normalk.z.T]="Fzf::Fs::C::Toggle normal.tac"
        [normalk.z.bind]="enter:ignore,f3:execute(</dev/tty man fzf >/dev/tty),f4:execute(</dev/tty man ls >/dev/tty),"
        [normalk.z.c]="Fzf::Fs::C::Toggle normal.cycle"
        [normalk.z.expect]="1,2,T,c,g,i,m,r,s,t,"
        [normalk.z.g]="Fzf::Fs::C::Set -i normal.margin"
        [normalk.z.i]="Fzf::Fs::C::Toggle normal.inline_info"
        [normalk.z.legend]=$'1 Set lc.collate.c\n2 Set lc.collate.lang\nT Toggle normal.tac\nc Toggle normal.cycle\ng Set normal.margin\ni Toggle normal.inline_info\nm Toggle normal.mouse\nr Toggle normal.reverse\ns Toggle normal.hscroll\nt Set normal.tabstop'
        [normalk.z.m]="Fzf::Fs::C::Toggle normal.mouse"
        [normalk.z.r]="Fzf::Fs::C::Toggle normal.reverse"
        [normalk.z.s]="Fzf::Fs::C::Toggle normal.hscroll"
        [normalk.z.t]="Fzf::Fs::C::Set -i normal.tabstop"
        [search.alt-e]="Fzf::Fs::C::Edit {}"
        [search.alt-h]="Fzf::Fs::C::Parent 1"
        [search.alt-i]="Fzf::Fs::C::Page {}"
        [search.alt-l]="Fzf::Fs::C::Child {}"
        [search.bind]="f4:execute(</dev/tty man fzf >/dev/tty),f3:execute(</dev/tty man fzf >/dev/tty),"
        [search.ctrl-c]="Fzf::Fs::C::Set normal.mode"
        [search.ctrl-g]="Fzf::Fs::C::Set normal.mode"
        [search.ctrl-m]="Fzf::Fs::C::Child {}"
        [search.ctrl-q]="Fzf::Fs::C::Quit"
        [search.enter]="Fzf::Fs::C::Child {}"
        [search.esc]="Fzf::Fs::C::Set normal.mode"
        [search.expect]='alt-e,alt-h,alt-i,alt-l,ctrl-c,ctrl-g,ctrl-m,ctrl-q,enter,esc,f1,'
        [search.f1]="Fzf::Fs::C::GetKey f1"
        [searchk.f1.1]="Fzf::Fs::C::Set search.theme.16"
        [searchk.f1.B]="Fzf::Fs::C::Set -i search.criteria"
        [searchk.f1.C]="Fzf::Fs::C::Toggle search.cycle"
        [searchk.f1.E]="Fzf::Fs::C::Toggle search.extended"
        [searchk.f1.H]="Fzf::Fs::C::Set -i search.history"
        [searchk.f1.S]="Fzf::Fs::C::Set -i search.history.size"
        [searchk.f1.T]="Fzf::Fs::C::Set search.tac"
        [searchk.f1.a]="Fzf::Fs::C::Set -i search.case"
        [searchk.f1.b]="Fzf::Fs::C::Toggle search.black"
        [searchk.f1.bind]="enter:ignore,f3:execute(</dev/tty man fzf >/dev/tty),f4:execute(</dev/tty man ls >/dev/tty),"
        [searchk.f1.c]="Fzf::Fs::C::Set -i search.theme"
        [searchk.f1.d]="Fzf::Fs::C::Set search.theme.dark"
        [searchk.f1.e]="Fzf::Fs::C::Toggle search.fuzzy"
        [searchk.f1.expect]="1,B,C,E,H,S,T,a,b,c,d,e,g,i,l,m,o,r,s,t,w,"
        [searchk.f1.g]="Fzf::Fs::C::Set -i search.margin"
        [searchk.f1.i]="Fzf::Fs::C::Toggle search.inline_info"
        [searchk.f1.l]="Fzf::Fs::C::Set search.theme.light"
        [searchk.f1.legend]=$'1 Set search.theme.16\nB Set search.criteria\nC Toggle search.cycle\nE Toggle search.extended\nH Set search.history\nS Set search.history.size\nT Toggle search.tac\na Set search.case\nb Toggle search.black\nc Set search.theme\nd Set search.theme.dark\ne Toggle search.fuzzy\ng Set search.margin\ni Toggle search.inline_info\nl Set search.theme.light\nm Toggle search.mouse\no Toggle search.sort\nr Toggle search.reverse\ns Toggle search.hscroll\nt Set search.tabstop\nw Set search.theme.bw'
        [searchk.f1.m]="Fzf::Fs::C::Toggle search.mouse"
        [searchk.f1.o]="Fzf::Fs::C::Toggle search.sort"
        [searchk.f1.r]="Fzf::Fs::C::Toggle search.reverse"
        [searchk.f1.s]="Fzf::Fs::C::Toggle search.hscroll"
        [searchk.f1.t]="Fzf::Fs::C::Set -i search.tabstop"
        [searchk.f1.w]="Fzf::Fs::C::Set search.theme.bw"
        [set.bind]="btab:toggle-out,ctrl-i:toggle-in,ctrl-r:toggle-sort,f1:select-all,f2:deselect-all,shift-tab:toggle-out,ctrl-v:toggle,tab:toggle-in,f3:toggle-all,"
        [set.expect]=
        [tog.bind]="btab:toggle-out,ctrl-i:toggle-in,ctrl-r:toggle-sort,f1:select-all,f2:deselect-all,shift-tab:toggle-out,ctrl-v:toggle,tab:toggle-in,f3:toggle-all,"
        [tog.expect]=
)
```
##### Environment and Configuration

Specify FZF_FS_CONF_DIR on the commandline, otherwise:
`${FZF_FS_CONF_DIR:-${XDG_CONFIG_HOME:-${HOME}/.config}/fzf-fs.d}`.

```sh
builtin typeset -x +i \
        FZF_DEFAULT_COMMAND= \
        FZF_DEFAULT_OPTS= \
        LC_COLLATE=C \
        TERMCMD=${TERMCMD:-xterm};

FzfFsVarsStr+=(
        [cursor.off]="$(command tput civis || command tput vi)"
        [cursor.on]="$(command tput cnorm || command tput ve)"
        [lc.collate.old]="$LC_COLLATE"
        [ls.default.opts]=
        [mode]=
        [prompt]=
)

FzfFsVarsInt+=(
        [interactive]=0
)

FzfFsOptsStr+=(
        [consolek.margin]="${FzfFsOptsStr[consolek.margin]:-"0,0,0,0"}"
        [consolek.tabstop]="${FzfFsOptsStr[consolek.tabstop]:-8}"
        [consolek.theme]="${FzfFsOptsStr[consolek.theme]:-bw}"
        [console.history]="${FzfFsOptsStr[console.history]}"
        [console.history.size]="${FzfFsOptsStr[console.history.size]:-1000}"
        [console.margin]="${FzfFsOptsStr[console.margin]:-"0,0,0,0"}"
        [console.tabstop]="${FzfFsOptsStr[console.tabstop]:-8}"
        [console.theme]="${FzfFsOptsStr[console.theme]:-bw}"
        [ls.lformat]="${FzfFsOptsStr[ls.lformat]:-l}"
        [ls.sort]="${FzfFsOptsStr[ls.sort]:-nothing}"
        [ls.time]="${FzfFsOptsStr[ls.time]:-mtime}"
        [normalk.margin]="${FzfFsOptsStr[normalk.margin]:-"0,0,0,0"}"
        [normalk.tabstop]="${FzfFsOptsStr[normalk.tabstop]:-8}"
        [normalk.theme]="${FzfFsOptsStr[normalk.theme]:-bw}"
        [normal.margin]="${FzfFsOptsStr[normal.margin]:-"0,0,0,0"}"
        [normal.tabstop]="${FzfFsOptsStr[normal.tabstop]:-8}"
        [normal.theme]="${FzfFsOptsStr[normal.theme]:-bw}"
        [os]="${FzfFsOptsStr[os]}"
        [searchk.margin]="${FzfFsOptsStr[searchk.margin]:-"0,0,0,0"}"
        [searchk.tabstop]="${FzfFsOptsStr[searchk.tabstop]:-8}"
        [searchk.theme]="${FzfFsOptsStr[searchk.theme]:-bw}"
        [search.case]="${FzfFsOptsStr[search.case]:-smart}"
        [search.criteria]="${FzfFsOptsStr[search.criteria]:-"length,index"}"
        [search.history]="${FzfFsOptsStr[search.history]}"
        [search.history.size]="${FzfFsOptsStr[search.history.size]:-1000}"
        [search.margin]="${FzfFsOptsStr[search.margin]:-"0,0,0,0"}"
        [search.tabstop]="${FzfFsOptsStr[search.tabstop]:-8}"
        [search.theme]="${FzfFsOptsStr[search.theme]:-bw}"
        [set.case]="${FzfFsOptsStr[set.case]:-smart}"
        [set.criteria]="${FzfFsOptsStr[set.criteria]:-"length,index"}"
        [set.margin]="${FzfFsOptsStr[set.margin]:-"0,0,0,0"}"
        [set.tabstop]="${FzfFsOptsStr[set.tabstop]:-8}"
        [set.theme]="${FzfFsOptsStr[set.theme]:-bw}"
        [tog.case]="${FzfFsOptsStr[tog.case]:-smart}"
        [tog.criteria]="${FzfFsOptsStr[tog.criteria]:-"length,index"}"
        [tog.margin]="${FzfFsOptsStr[tog.margin]:-"0,0,0,0"}"
        [tog.tabstop]="${FzfFsOptsStr[tog.tabstop]:-8}"
        [tog.theme]="${FzfFsOptsStr[tog.theme]:-bw}"
)

FzfFsOptsInt+=(
        [consolek.black]=FzfFsOptsInt[consolek.black]
        [consolek.cycle]=FzfFsOptsInt[consolek.cycle]
        [consolek.hscroll]="${FzfFsOptsInt[consolek.hscroll]:-1}"
        [consolek.inline_info]=FzfFsOptsInt[consolek.inline_info]
        [consolek.mouse]=FzfFsOptsInt[consolek.mouse]
        [consolek.reverse]="${FzfFsOptsInt[consolek.reverse]:-1}"
        [consolek.tac]=FzfFsOptsInt[consolek.tac]
        [console.black]=FzfFsOptsInt[console.black]
        [console.cycle]=FzfFsOptsInt[console.cycle]
        [console.hscroll]="${FzfFsOptsInt[console.hscroll]:-1}"
        [console.inline_info]=FzfFsOptsInt[console.inline_info]
        [console.mouse]=FzfFsOptsInt[console.mouse]
        [console.reverse]=FzfFsOptsInt[console.reverse]
        [console.tac]=FzfFsOptsInt[console.tac]
        [cursor]=FzfFsOptsInt[cursor]
        [ls.F]=FzfFsOptsInt[ls.F]
        [ls.H]=FzfFsOptsInt[ls.H]
        [ls.L]=FzfFsOptsInt[ls.L]
        [ls.color]=FzfFsOptsInt[ls.color]
        [ls.h]=FzfFsOptsInt[ls.h]
        [ls.hidden]=FzfFsOptsInt[ls.hidden]
        [ls.k]=FzfFsOptsInt[ls.k]
        [ls.long]=FzfFsOptsInt[ls.long]
        [ls.p]="${FzfFsOptsInt[ls.p]:-1}"
        [ls.r]=FzfFsOptsInt[ls.r]
        [ls.s]=FzfFsOptsInt[ls.s]
        [normalk.black]=FzfFsOptsInt[normalk.black]
        [normalk.cycle]=FzfFsOptsInt[normalk.cycle]
        [normalk.hscroll]="${FzfFsOptsInt[normalk.hscroll]:-1}"
        [normalk.inline_info]=FzfFsOptsInt[normalk.inline_info]
        [normalk.mouse]=FzfFsOptsInt[normalk.mouse]
        [normalk.reverse]="${FzfFsOptsInt[normalk.reverse]:-1}"
        [normalk.tac]=FzfFsOptsInt[normalk.tac]
        [normal.black]=FzfFsOptsInt[normal.black]
        [normal.cycle]=FzfFsOptsInt[normal.cycle]
        [normal.hscroll]="${FzfFsOptsInt[normal.hscroll]:-1}"
        [normal.inline_info]=FzfFsOptsInt[normal.inline_info]
        [normal.mouse]=FzfFsOptsInt[normal.mouse]
        [normal.reverse]="${FzfFsOptsInt[normal.reverse]:-1}"
        [normal.tac]=FzfFsOptsInt[normal.tac]
        [searchk.black]=FzfFsOptsInt[searchk.black]
        [searchk.cycle]=FzfFsOptsInt[searchk.cycle]
        [searchk.hscroll]="${FzfFsOptsInt[searchk.hscroll]:-1}"
        [searchk.inline_info]=FzfFsOptsInt[searchk.inline_info]
        [searchk.mouse]=FzfFsOptsInt[searchk.mouse]
        [searchk.reverse]="${FzfFsOptsInt[searchk.reverse]:-1}"
        [searchk.tac]=FzfFsOptsInt[searchk.tac]
        [search.black]=FzfFsOptsInt[search.black]
        [search.cycle]=FzfFsOptsInt[search.cycle]
        [search.extended]="${FzfFsOptsInt[search.extended]:-1}"
        [search.fuzzy]=FzfFsOptsInt[search.fuzzy]
        [search.hscroll]="${FzfFsOptsInt[search.hscroll]:-1}"
        [search.inline_info]=FzfFsOptsInt[search.inline_info]
        [search.mouse]=FzfFsOptsInt[search.mouse]
        [search.reverse]=FzfFsOptsInt[search.reverse]
        [search.sort]="${FzfFsOptsInt[search.sort]:-1}"
        [search.tac]=FzfFsOptsInt[search.tac]
        [set.black]=FzfFsOptsInt[set.black]
        [set.cycle]=FzfFsOptsInt[set.cycle]
        [set.extended]="${FzfFsOptsInt[set.extended]:-1}"
        [set.fuzzy]=FzfFsOptsInt[set.fuzzy]
        [set.hscroll]="${FzfFsOptsInt[set.hscroll]:-1}"
        [set.inline_info]=FzfFsOptsInt[set.inline_info]
        [set.mouse]=FzfFsOptsInt[set.mouse]
        [set.reverse]=FzfFsOptsInt[set.reverse]
        [set.sort]="${FzfFsOptsInt[set.sort]:-1}"
        [set.tac]=FzfFsOptsInt[set.tac]
        [tog.black]=FzfFsOptsInt[tog.black]
        [tog.cycle]=FzfFsOptsInt[tog.cycle]
        [tog.extended]="${FzfFsOptsInt[tog.extended]:-1}"
        [tog.fuzzy]=FzfFsOptsInt[tog.fuzzy]
        [tog.hscroll]="${FzfFsOptsInt[tog.hscroll]:-1}"
        [tog.inline_info]=FzfFsOptsInt[tog.inline_info]
        [tog.mouse]=FzfFsOptsInt[tog.mouse]
        [tog.reverse]=FzfFsOptsInt[tog.reverse]
        [tog.sort]="${FzfFsOptsInt[tog.sort]:-1}"
        [tog.tac]=FzfFsOptsInt[tog.tac]
)

FzfOptsStr+=(
        #[case]=""
        [black.0]="--no-black "
        [black.1]="--black "
        [criteria]="--tiebreak="
        [cycle.0]="--no-cycle "
        [cycle.1]="--cycle "
        [extended.0]="--no-extended "
        [extended.1]="--extended "
        [fuzzy.0]="--exact "
        [fuzzy.1]="--no-exact "
        [history]="--history="
        [history.size]="--history-size="
        [hscroll.0]="--no-hscroll "
        [hscroll.1]="--hscroll "
        [inline_info.0]="--no-inline-info "
        [inline_info.1]="--inline-info "
        [margin]="--margin="
        [mouse.0]="--no-mouse "
        [mouse.1]="--mouse "
        [reverse.0]="--no-reverse "
        [reverse.1]="--reverse "
        [sort.0]="--no-sort "
        [sort.1]="--sort "
        [tabstop]="--tabstop="
        [tac.0]="--no-tac "
        [tac.1]="--tac "
        [theme]="--color="
)

LsOptsStr+=(
        [F.1]=F
        [H.1]=H
        [hidden.1]=a
        [L.1]=L
        [h.1]=h
        [k.1]=k
        [p.1]=p
        [r.1]=r
        [s.1]=s
)

FzfFsSettingsStr+=(
        [console.mode]=FzfFsVarsStr[mode]=console
        [console.theme.16]=FzfFsOptsStr[console.theme]=16
        [console.theme.bw]=FzfFsOptsStr[console.theme]=bw
        [console.theme.dark]=FzfFsOptsStr[console.theme]=dark
        [console.theme.light]=FzfFsOptsStr[console.theme]=light
        [consolek.theme.16]=FzfFsOptsStr[consolek.theme]=16
        [consolek.theme.bw]=FzfFsOptsStr[consolek.theme]=bw
        [consolek.theme.dark]=FzfFsOptsStr[consolek.theme]=dark
        [consolek.theme.light]=FzfFsOptsStr[consolek.theme]=light
        [lc.collate.c]=LC_COLLATE=C
        [lc.collate.lang]=LC_COLLATE="$LANG"
        [ls.sort.atime]=FzfFsOptsStr[ls.sort]=atime
        [ls.sort.bname]=FzfFsOptsStr[ls.sort]=bname
        [ls.sort.ctime]=FzfFsOptsStr[ls.sort]=ctime
        [ls.sort.mtime]=FzfFsOptsStr[ls.sort]=mtime
        [ls.sort.nothing]=FzfFsOptsStr[ls.sort]=nothing
        [ls.sort.size]=FzfFsOptsStr[ls.sort]=size
        [ls.time.atime]=FzfFsOptsStr[ls.time]=atime
        [ls.time.ctime]=FzfFsOptsStr[ls.time]=ctime
        [ls.time.mtime]=FzfFsOptsStr[ls.time]=mtime
        [normal.mode]=FzfFsVarsStr[mode]=normal
        [normal.theme.16]=FzfFsOptsStr[normal.theme]=16
        [normal.theme.bw]=FzfFsOptsStr[normal.theme]=bw
        [normal.theme.dark]=FzfFsOptsStr[normal.theme]=dark
        [normal.theme.light]=FzfFsOptsStr[normal.theme]=light
        [normalk.theme.16]=FzfFsOptsStr[normalk.theme]=16
        [normalk.theme.bw]=FzfFsOptsStr[normalk.theme]=bw
        [normalk.theme.dark]=FzfFsOptsStr[normalk.theme]=dark
        [normalk.theme.light]=FzfFsOptsStr[normalk.theme]=light
        [search.mode]=FzfFsVarsStr[mode]=search
        [search.theme.16]=FzfFsOptsStr[search.theme]=16
        [search.theme.bw]=FzfFsOptsStr[search.theme]=bw
        [search.theme.dark]=FzfFsOptsStr[search.theme]=dark
        [search.theme.light]=FzfFsOptsStr[search.theme]=light
        [searchk.theme.16]=FzfFsOptsStr[searchk.theme]=16
        [searchk.theme.bw]=FzfFsOptsStr[searchk.theme]=bw
        [searchk.theme.dark]=FzfFsOptsStr[searchk.theme]=dark
        [searchk.theme.light]=FzfFsOptsStr[searchk.theme]=light
        [set.theme.16]=FzfFsOptsStr[set.theme]=16
        [set.theme.bw]=FzfFsOptsStr[set.theme]=bw
        [set.theme.dark]=FzfFsOptsStr[set.theme]=dark
        [set.theme.light]=FzfFsOptsStr[set.theme]=light
        [tog.theme.16]=FzfFsOptsStr[tog.theme]=16
        [tog.theme.bw]=FzfFsOptsStr[tog.theme]=bw
        [tog.theme.dark]=FzfFsOptsStr[tog.theme]=dark
        [tog.theme.light]=FzfFsOptsStr[tog.theme]=light
)
```

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


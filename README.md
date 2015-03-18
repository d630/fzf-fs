### fzf-fs v0.1.0 [MIT]

`fzf-fs`(1) acts like a very simple file browser/navigator for the command line by taking advantage of the general-purpose fuzzy finder [fzf](https://github.com/junegunn/fzf).

`fzf-fs`(1) is written in `GNU bash`(1), but it should also work out in `zsh`(1). It follows the Utilities portion of the POSIX specification and has been tested on `Debian GNU/Linux 8 (jessie)` with these programs/packages:

- BSD file 5.22
- GNU bash 4.3.30
- GNU coreutils 8.23: basename, ls, md5sum
- GNU findutils 4.4.2: find
- GNU sed 4.2.2
- XTerm(312)
- fzf 0.9.4 (Go version)
- less 458 (GNU regular expressions)
- ncurses 5.9.20140913: tput
- w3m 0.5.3 + patch/option w3m-img
- zsh 5.0.7

Notice that `fzf-fs`(1) contains a (modified) function, that is part of [liquidprompt](https://github.com/nojhan/liquidprompt/blob/master/liquidprompt).

#### Bugs & Requests

Report it on https://github.com/D630/fzf-fs/issues

#### Git

To dowload the very latest source:

```
git clone https://github.com/D630/fzf-fs
```

If you also want to use the latest tagged version, do something like this:

```
cd ./fzf-fs
git checkout $(git describe --abbrev=0 --tags)
```

#### Usage

Just execute or source the `fzf-fs.sh` and then select one line in `fzf`(1):

```sh
% source fzf-fs.sh
% source fzf-fs.sh <DIR>
% source fzf-fs.sh <DIR>/
% source fzf-fs.sh .
% source fzf-fs.sh ..
% source fzf-fs.sh ~
% source fzf-fs.sh ~/
```

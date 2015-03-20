.TH "fzf-fs" "1" "Fri Mar 20 04:08:58 CET 2015" "0.1.8" "README"

##### README

fzf-fs(1) acts like a very simple file browser/navigator for the command line by taking advantage of the general-purpose fuzzy finder [fzf](https://github.com/junegunn/fzf). Although coming without Miller columns, fzf-fs(1) is inspired by tools like [lscd](https://github.com/hut/lscd) and [deer](https://github.com/vifon/deer), which both follow the example set by [ranger](https://github.com/hut/ranger).

Get in touch with fzf-fs(1) by reading the [USAGE](../master/doc/USAGE.md) text file. Have also a look at the [TODO](../master/doc/TODO.md) document.

fzf-fs(1) uses the same [license](https://github.com/junegunn/fzf#license) like fzf(1). Notice that fzf-fs(1) contains a (modified) function, that is part of [liquidprompt](https://github.com/nojhan/liquidprompt/blob/master/liquidprompt).

##### BUGS & REQUESTS

Feel free to open an issue or put in a pull request on https://github.com/D630/fzf-fs

##### GIT

To download the very latest source:

```
git clone https://github.com/D630/fzf-fs
```

If you also want to use the latest tagged version, do something like this:

```
cd ./fzf-fs
git checkout $(git describe --abbrev=0 --tags)
```

##### NOTICE

`fzf-fs`(1) is written in `GNU bash`(1) and follows the Utilities portion of the POSIX specification. It has been tested on `Debian GNU/Linux 8 (jessie)` with these programs/packages:

- GNU bash 4.3.30
- GNU coreutils 8.23: basename, echo, ls, md5sum, sort, tail
- GNU findutils 4.4.2: find
- GNU nano version 2.2.6
- GNU sed 4.2.2
- XTerm(312)
- fzf 0.9.4 (Go version)
- less 458 (GNU regular expressions)
- ncurses 5.9.20140913: tput

---
layout: post
title:  "Upgrading git command to latest version in Mac"
date:   2022-04-17 17:03:00 -0400
categories: mac git
---

# Motivation

Last week while facing a git challenge with multiple remote, I found there is new command `git switch` which is introduced in release [2.23.0](https://github.com/git/git/blob/master/Documentation/RelNotes/2.23.0.txt#L61). I was using git version [2.16.2](https://github.com/git/git/blob/master/Documentation/RelNotes/2.16.2.txt) which is 4 years old.

While planning to learn `git switch`, I learned few new commands in `brew`. 

## Highlights

- `brew list <formula>` ==> summarise the paths within its current keg.
- `brew update` ==> Fetch the newest version of Homebrew and all formulae. Does not install anything. Just updates the local inventory of formule and its versions.
- `brew outdated` ==> List installed casks and formulae that have an updated version available.
- `brew upgrade` ==> Upgrade all or specific formula.

## Console output

```
mm-laptop:~ mahendran$ git --version
git version 2.16.2


mm-laptop:~ mahendran$ brew list git
/usr/local/Cellar/git/2.16.2/.bottle/etc/gitconfig
/usr/local/Cellar/git/2.16.2/bin/git
/usr/local/Cellar/git/2.16.2/bin/git-cvsserver
/usr/local/Cellar/git/2.16.2/bin/git-receive-pack
/usr/local/Cellar/git/2.16.2/bin/git-shell
/usr/local/Cellar/git/2.16.2/bin/git-upload-archive
/usr/local/Cellar/git/2.16.2/bin/git-upload-pack
/usr/local/Cellar/git/2.16.2/bin/gitk
/usr/local/Cellar/git/2.16.2/etc/bash_completion.d/ (2 files)
/usr/local/Cellar/git/2.16.2/lib/perl5/ (14 files)
/usr/local/Cellar/git/2.16.2/libexec/git-core/ (193 files)
/usr/local/Cellar/git/2.16.2/share/doc/ (832 files)
/usr/local/Cellar/git/2.16.2/share/emacs/ (2 files)
/usr/local/Cellar/git/2.16.2/share/git-core/ (182 files)
/usr/local/Cellar/git/2.16.2/share/git-gui/ (57 files)
/usr/local/Cellar/git/2.16.2/share/gitk/ (13 files)
/usr/local/Cellar/git/2.16.2/share/gitweb/ (5 files)
/usr/local/Cellar/git/2.16.2/share/man/ (178 files)
/usr/local/Cellar/git/2.16.2/share/zsh/ (2 files)
mm-laptop:~ mahendran$
mm-laptop:~ mahendran$ brew update
mm-laptop:~ mahendran$ brew outdated
.... removed unwanted
git (2.16.2) < 2.35.1
.... removed unwanted
mm-laptop:~ mahendran$ brew upgrade git
Running `brew update --preinstall`...
Ignoring path homebrew-cask/
To restore the stashed changes to /usr/local/Homebrew/Library/Taps/homebrew/homebrew-cask, run:
  cd /usr/local/Homebrew/Library/Taps/homebrew/homebrew-cask && git stash pop
==> Auto-updated Homebrew!
Updated 2 taps (homebrew/core and homebrew/cask).
==> New Formulae
criterion                    difftastic                   gops                         httpyac                      kmod                         libmarpa                     mongodb-atlas-cli            ugit
ddcutil                      ecflow-ui                    highs                        imposm3                      libcython                    mariadb@10.6                 nvchecker
==> Updated Formulae
Updated 429 formulae.
==> Deleted Formulae
boost-python                                                                                                          komposition
==> New Casks
accord               anypointstudio       audiorelay           bettermouse          free-gpgmail         kdenlive             osp-tracker          polymc               postman-agent        readyapi             warp
==> Updated Casks
Updated 368 casks.

==> Upgrading 1 outdated package:
git 2.16.2 -> 2.35.1
==> Downloading https://ghcr.io/v2/homebrew/core/gettext/manifests/0.21
######################################################################## 100.0%
==> Downloading https://ghcr.io/v2/homebrew/core/gettext/blobs/sha256:a025e143fe3f5f7e24a936b8b0a4926acfdd025b11d62024e3d355c106536d56
==> Downloading from https://pkg-containers.githubusercontent.com/ghcr1/blobs/sha256:a025e143fe3f5f7e24a936b8b0a4926acfdd025b11d62024e3d355c106536d56?se=2022-04-10T11%3A40%3A00Z&sig=v9IqxABsSQxY4tL7n5Rz4aVedbhM%2B0x3a0qqjfG5Y2U%3D&sp=
######################################################################## 100.0%
==> Downloading https://ghcr.io/v2/homebrew/core/pcre2/manifests/10.39
######################################################################## 100.0%
==> Downloading https://ghcr.io/v2/homebrew/core/pcre2/blobs/sha256:3b6478346d722d13c9dd556a90949319417224006939b1e46b06a189dc8c5262
==> Downloading from https://pkg-containers.githubusercontent.com/ghcr1/blobs/sha256:3b6478346d722d13c9dd556a90949319417224006939b1e46b06a189dc8c5262?se=2022-04-10T11%3A40%3A00Z&sig=FEGdTk0Fwum2Z1G11Kcq4X68wWxm9ntTgy3Z3vK7VR0%3D&sp=r&
######################################################################## 100.0%
==> Downloading https://ghcr.io/v2/homebrew/core/git/manifests/2.35.1
######################################################################## 100.0%
==> Downloading https://ghcr.io/v2/homebrew/core/git/blobs/sha256:212244b5acaaa49fdd33b710fc6795c457aa25e89a854d39407bf36532137ef8
==> Downloading from https://pkg-containers.githubusercontent.com/ghcr1/blobs/sha256:212244b5acaaa49fdd33b710fc6795c457aa25e89a854d39407bf36532137ef8?se=2022-04-10T11%3A40%3A00Z&sig=RVBQ%2FeXIMmZ7Am0dfg7ELf6IL01rFNbYBqVhMo7lW5A%3D&sp=
######################################################################## 100.0%
==> Upgrading git
  2.16.2 -> 2.35.1 

==> Installing dependencies for git: gettext and pcre2
==> Installing git dependency: gettext
==> Pouring gettext--0.21.big_sur.bottle.tar.gz
🍺  /usr/local/Cellar/gettext/0.21: 1,953 files, 19.8MB
==> Installing git dependency: pcre2
==> Pouring pcre2--10.39.big_sur.bottle.tar.gz
🍺  /usr/local/Cellar/pcre2/10.39: 230 files, 6.2MB
==> Installing git
==> Pouring git--2.35.1.big_sur.bottle.tar.gz
==> Caveats
The Tcl/Tk GUIs (e.g. gitk, git-gui) are now in the `git-gui` formula.
Subversion interoperability (git-svn) is now in the `git-svn` formula.

Bash completion has been installed to:
  /usr/local/etc/bash_completion.d

Emacs Lisp files have been installed to:
  /usr/local/share/emacs/site-lisp/git
==> Summary
🍺  /usr/local/Cellar/git/2.35.1: 1,523 files, 43MB
==> Running `brew cleanup git`...
Disable this behaviour by setting HOMEBREW_NO_INSTALL_CLEANUP.
Hide these hints with HOMEBREW_NO_ENV_HINTS (see `man brew`).
Removing: /usr/local/Cellar/git/2.16.2... (1,492 files, 34.4MB)
==> Upgrading 1 dependent of upgraded formulae:
Disable this behaviour by setting HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK.
Hide these hints with HOMEBREW_NO_ENV_HINTS (see `man brew`).
watch 3.3.15 -> 4.0.0
==> Downloading https://ghcr.io/v2/homebrew/core/ncurses/manifests/6.3
######################################################################## 100.0%
==> Downloading https://ghcr.io/v2/homebrew/core/ncurses/blobs/sha256:15ee5cba182428fe2bcd80da6605214104b77e808a484c97ab281741f1a66a06
==> Downloading from https://pkg-containers.githubusercontent.com/ghcr1/blobs/sha256:15ee5cba182428fe2bcd80da6605214104b77e808a484c97ab281741f1a66a06?se=2022-04-10T11%3A40%3A00Z&sig=pPchD4qYkk4ok7VcNPUY6D1BcxZJjVcDKNe4p4T1CHM%3D&sp=r&
######################################################################## 100.0%
==> Downloading https://ghcr.io/v2/homebrew/core/watch/manifests/4.0.0
######################################################################## 100.0%
==> Downloading https://ghcr.io/v2/homebrew/core/watch/blobs/sha256:77383edb8de69055e0156ac24ba26f9c786b0d40e72d8e72a2c068d36f64c45e
==> Downloading from https://pkg-containers.githubusercontent.com/ghcr1/blobs/sha256:77383edb8de69055e0156ac24ba26f9c786b0d40e72d8e72a2c068d36f64c45e?se=2022-04-10T11%3A40%3A00Z&sig=lbPVE%2B6ABPD601ipJN1Wj7pFb3bLhMF%2BTEflb%2BET%2BD0%
######################################################################## 100.0%
==> Upgrading watch
  3.3.15 -> 4.0.0 

==> Installing dependencies for watch: ncurses
==> Installing watch dependency: ncurses
==> Pouring ncurses--6.3.big_sur.bottle.tar.gz
🍺  /usr/local/Cellar/ncurses/6.3: 3,968 files, 9.3MB
==> Installing watch
==> Pouring watch--4.0.0.big_sur.bottle.tar.gz
🍺  /usr/local/Cellar/watch/4.0.0: 10 files, 139.8KB
==> Running `brew cleanup watch`...
Removing: /usr/local/Cellar/watch/3.3.15... (9 files, 80.9KB)
==> Checking for dependents of upgraded formulae...
==> No broken dependents found!
==> Caveats
==> git
The Tcl/Tk GUIs (e.g. gitk, git-gui) are now in the `git-gui` formula.
Subversion interoperability (git-svn) is now in the `git-svn` formula.

Bash completion has been installed to:
  /usr/local/etc/bash_completion.d

Emacs Lisp files have been installed to:
  /usr/local/share/emacs/site-lisp/git
mm-laptop:~ mahendran$ git --version
git version 2.35.1
mm-laptop:~ mahendran$ 

```

From macOS Big Sur (M1) - where git comes with OS.
```
mahendran@mm-lab ~ % git version
git version 2.30.1 (Apple Git-130)
mahendran@mm-lab ~ % brew outdated      
aws-iam-authenticator (0.5.3) < 0.5.7
bazel (4.2.1_1) < 5.1.1
ca-certificates (2021-10-26) < 2022-03-29
coursier/formulas/coursier (2.0.13) < 2.1.0-M5-18-gfebf9838c
weaveworks/tap/eksctl (0.67.0) < 0.93.0
go (1.16) < 1.18.1
helm (3.5.1) < 3.8.2
hugo (0.82.0) < 0.97.3
icu4c (69.1) < 70.1
krb5 (1.19.2) < 1.19.3
kubernetes-cli (1.22.2) < 1.23.5
libnghttp2 (1.46.0) < 1.47.0
libuv (1.42.0) < 1.44.1
node (17.3.0) < 17.9.0
oniguruma (6.9.6) < 6.9.7.1
openjdk (15.0.2) < 18
openjdk@11 (11.0.12) < 11.0.14.1
openssl@1.1 (1.1.1m) < 1.1.1n
postgresql@12 (12.9_1) < 12.10_1
readline (8.1.1) < 8.1.2
ruby (3.0.3) < 3.1.2
ruby-build (20211225) < 20220415
socat (1.7.4.1) < 1.7.4.3
adoptopenjdk (15,36) != 16.0.1,9
adoptopenjdk8 (8,275:b01) != 8,292:b10
temurin (17.0.1,12) != 18,36
mahendran@mm-lab ~ %
mahendran@mm-lab ~ % brew install git
### This install failed and resulted into terminating git command like mentioned in this stackoverflow question - https://stackoverflow.com/questions/66119081/why-does-zsh-kills-my-process-every-time-i-enter-a-git-command
mahendran@mm-lab ~ % brew uninstall git
Uninstalling /opt/homebrew/Cellar/git/2.36.0... (1,544 files, 44.3MB)

Warning: The following may be git configuration files and have not been removed!
If desired, remove them manually with `rm -rf`:
  /opt/homebrew/etc/gitconfig
mahendran@mm-lab ~ % brew update
Already up-to-date.
mahendran@mm-lab ~ % brew reinstall pcre2 gettext
==> Downloading https://ghcr.io/v2/homebrew/core/pcre2/manifests/10.39
Already downloaded: /Users/mahendran/Library/Caches/Homebrew/downloads/d04cf1b7feb00f01719e307014af7b7e0bdd32565eb226a2782f259934e3fe9b--pcre2-10.39.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/pcre2/blobs/sha256:935bb0c71f1ab79e0ef2593b519b62b5489d87d4571b320cd8f93050c820c450
Already downloaded: /Users/mahendran/Library/Caches/Homebrew/downloads/56c946aabe1e21374a5e6707d3ff6efa3f75f5476c1ce6940895b0b34c087c4f--pcre2--10.39.arm64_big_sur.bottle.tar.gz
==> Reinstalling pcre2 
==> Pouring pcre2--10.39.arm64_big_sur.bottle.tar.gz
🍺  /opt/homebrew/Cellar/pcre2/10.39: 230 files, 6MB
==> Running `brew cleanup pcre2`...
Disable this behaviour by setting HOMEBREW_NO_INSTALL_CLEANUP.
Hide these hints with HOMEBREW_NO_ENV_HINTS (see `man brew`).
==> Downloading https://ghcr.io/v2/homebrew/core/gettext/manifests/0.21
######################################################################## 100.0%
==> Downloading https://ghcr.io/v2/homebrew/core/gettext/blobs/sha256:339b62b52ba86dfa73091d37341104b46c01ae354ca425000732df689305442b
==> Downloading from https://pkg-containers.githubusercontent.com/ghcr1/blobs/sha256:339b62b52ba86dfa73091d37341104b46c01ae354ca425000732df689305442b?
######################################################################## 100.0%
==> Reinstalling gettext 
==> Pouring gettext--0.21.arm64_big_sur.bottle.tar.gz
🍺  /opt/homebrew/Cellar/gettext/0.21: 1,953 files, 20.8MB
==> Running `brew cleanup gettext`...
mahendran@mm-lab ~ % brew install git
==> Downloading https://ghcr.io/v2/homebrew/core/git/manifests/2.36.0
Already downloaded: /Users/mahendran/Library/Caches/Homebrew/downloads/2af5227059553ebe42a3d1cd8a92e69876a28cbf5da88c0c92562c2598444464--git-2.36.0.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/git/blobs/sha256:79fc92c8bb40f2d9e9f4ebba14d313b31de03fd30da57f3aa526228391abce53
Already downloaded: /Users/mahendran/Library/Caches/Homebrew/downloads/fdf8140ffc965e35228429f802871570a39909a3d6b284630be4561e7c19495e--git--2.36.0.arm64_big_sur.bottle.tar.gz
==> Pouring git--2.36.0.arm64_big_sur.bottle.tar.gz
==> Caveats
The Tcl/Tk GUIs (e.g. gitk, git-gui) are now in the `git-gui` formula.
Subversion interoperability (git-svn) is now in the `git-svn` formula.

zsh completions and functions have been installed to:
  /opt/homebrew/share/zsh/site-functions

Emacs Lisp files have been installed to:
  /opt/homebrew/share/emacs/site-lisp/git
==> Summary
🍺  /opt/homebrew/Cellar/git/2.36.0: 1,544 files, 44.3MB
==> Running `brew cleanup git`...
Disable this behaviour by setting HOMEBREW_NO_INSTALL_CLEANUP.
Hide these hints with HOMEBREW_NO_ENV_HINTS (see `man brew`).
mahendran@mm-lab ~ % git version
git version 2.30.1 (Apple Git-130)
mahendran@mm-lab ~ % git --version
git version 2.30.1 (Apple Git-130)
mahendran@mm-lab ~ % /opt/homebrew/Cellar/git/2.36.0/bin/git version
git version 2.36.0
mahendran@mm-lab ~ % source ~/.zshrc 
mahendran@mm-lab ~ % git --version                                  
git version 2.36.0
mahendran@mm-lab ~ % /usr/bin/git version
git version 2.30.1 (Apple Git-130)
mahendran@mm-lab ~ %
```

## Learnings
- Git also offers [binarry installer](http://git-scm.com/download/mac).
- In Mac M1, `brew install git` did not work straight away.
- It is recommended to run `brew cleanup`, `brew update` regular interval (every day/week) right after the backup runs.
- Remember about `git switch` and `git restore` before using `git checkout`.
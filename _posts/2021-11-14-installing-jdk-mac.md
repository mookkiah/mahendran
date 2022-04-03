---
layout: post
title:  "Installing JDK on Mac"
date:   2021-11-14 06:55:00 -0400
modified_date:   2022-04-03 09:34:00  -0400
categories: mac java
---

# Multiple ways
Multiple implementors of JDK gives multiple options to instlall JDK for each operating system.
In all those installations JDK contents extracted into a directory which makes more sense for the operating system. We can also download the compressed content and extract. It is recommended to choose an approach and stick with it while installing multiple version.

Here are few ways I know of installing JDK
- Extract zip/tgz
- Commandline install using brew
- Commandline install using sdkman
- GUI install using package

Most prefered/recommended way is the operating system way for end user/developer. Which usually download the package from the JDK vendor and installing with user interface. For Windows, installer executable, for linux yum/rpm packages, for mac app package.

I use brew to install all development related tools/library/kit. So I decided to use it for JDK install as well.

Mac places the Java Virtual Machines under `/Library/Java/JavaVirtualMachines` folder when installing as mac application. If we are using any other approach, installation recommends us to create symlink to this folder if it installs in other directory.

Here is two output which you can understand this
```shell
$ /usr/libexec/java_home -V             
Matching Java Virtual Machines (4):
    17.0.1 (x86_64) "Eclipse Temurin" - "Eclipse Temurin 17" /Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Home
    15 (x86_64) "AdoptOpenJDK" - "AdoptOpenJDK 15" /Library/Java/JavaVirtualMachines/adoptopenjdk-15.jdk/Contents/Home
    11.0.12 (arm64) "Homebrew" - "OpenJDK 11.0.12" /opt/homebrew/Cellar/openjdk@11/11.0.12/libexec/openjdk.jdk/Contents/Home
    1.8.0_275 (x86_64) "AdoptOpenJDK" - "AdoptOpenJDK 8" /Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home
/Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Home

$ ls -l /Library/Java/JavaVirtualMachines
total 0
drwxr-xr-x  3 root  wheel  96 Dec 29  2020 adoptopenjdk-15.jdk
drwxr-xr-x  3 root  wheel  96 Nov  9  2020 adoptopenjdk-8.jdk
lrwxr-xr-x  1 root  wheel  48 Nov 10 07:01 openjdk-11.jdk -> /opt/homebrew/opt/openjdk@11/libexec/openjdk.jdk
drwxr-xr-x  3 root  wheel  96 Sep 15  2021 temurin-17.jdk
```
Here I installed OpenJDK 11 using homebrew.

Another machine...
```
$ /usr/libexec/java_home --verbose
Matching Java Virtual Machines (6):
    18 (x86_64) "Homebrew" - "OpenJDK 18" /usr/local/Cellar/openjdk/18/libexec/openjdk.jdk/Contents/Home
    17.0.2 (x86_64) "Eclipse Temurin" - "Eclipse Temurin 17" /Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Home
    15.0.1 (x86_64) "AdoptOpenJDK" - "AdoptOpenJDK 15" /Library/Java/JavaVirtualMachines/adoptopenjdk-15.jdk/Contents/Home
    11.0.5 (x86_64) "AdoptOpenJDK" - "AdoptOpenJDK 11" /Library/Java/JavaVirtualMachines/adoptopenjdk-11.jdk/Contents/Home
    1.8.181.13 (x86_64) "Oracle Corporation" - "Java" /Library/Internet Plug-Ins/JavaAppletPlugin.plugin/Contents/Home
    1.8.0_151 (x86_64) "Oracle Corporation" - "Java SE 8" /Library/Java/JavaVirtualMachines/jdk1.8.0_151.jdk/Contents/Home
/usr/local/Cellar/openjdk/18/libexec/openjdk.jdk/Contents/Home
$ pwd
/Library/Java/JavaVirtualMachines
$ ls -l /Library/Java/JavaVirtualMachines
total 0
drwxr-xr-x  3 root  wheel  96 Jan 15  2020 adoptopenjdk-11.jdk
drwxr-xr-x  3 root  wheel  96 Nov 30  2020 adoptopenjdk-15.jdk
drwxr-xr-x  3 root  wheel  96 Oct 19  2017 jdk1.8.0_151.jdk
lrwxr-xr-x  1 root  wheel  42 Apr  3 09:30 openjdk.jdk -> /usr/local/opt/openjdk/libexec/openjdk.jdk
drwxr-xr-x  3 root  wheel  96 Jan 20 13:22 temurin-17.jdk

```
Here I installed OpenJDK 18 using Homebrew. During the install it asked me to symblink (`sudo ln -sfn /usr/local/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk`). I dont like the fact that recommendation not specific to version 18.



  While you have multiple options to install JDK, Choose the one which you are familiar. If first time choose the operating system way. 

## Installing JDK 11 using brew
```shell
mahendran@mm-lab mahendran % brew install openjdk@11
mahendran@mm-lab mahendran % export JAVA_HOME=$(/usr/libexec/java_home -v11);
mahendran@mm-lab mahendran % java -version
openjdk version "11.0.12" 2021-07-20
OpenJDK Runtime Environment Homebrew (build 11.0.12+0)
OpenJDK 64-Bit Server VM Homebrew (build 11.0.12+0, mixed mode)
```


## Installing JDK 17 using brew cask
OpenJDK distributions from AdoptOpenJDK now called `Eclipse Temurin`

```shell
mahendran@mm-lab mahendran % brew install --cask temurin
Updating Homebrew...
==> Auto-updated Homebrew!
Updated 3 taps (weaveworks/tap, homebrew/core and homebrew/cask).
==> New Formulae
kubeval                     pip-tools                   tfmigrate                   tfproviderlint              urlwatch
==> Updated Formulae
Updated 237 formulae.
==> Deleted Formulae
amap
==> New Casks
fotokasten                                     pichon                                         replacicon
==> Updated Casks
Updated 186 casks.
==> Deleted Casks
armitage                                                              globalmeet
Warning: Calling bottle :unneeded is deprecated! There is no replacement.
Please report this issue to the weaveworks/tap tap (not Homebrew/brew or Homebrew/core):
  /opt/homebrew/Library/Taps/weaveworks/homebrew-tap/Formula/eksctl.rb:9


==> Downloading https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.1%2B12/OpenJDK17U-jdk_x64_mac_hotspot_17.0.1_12.p
==> Downloading from https://github-releases.githubusercontent.com/372925194/75c5a263-32f3-499c-bb2d-3aee522d0bec?X-Amz-Algorithm=AWS4-HMAC
######################################################################## 100.0%
==> Installing Cask temurin
==> Running installer for temurin; your password may be necessary.
Package installers may write to any location; options such as `--appdir` are ignored.
Password:
installer: Package name is Eclipse Temurin
installer: Upgrading at base path /
installer: The upgrade was successful.
🍺  temurin was successfully installed!
mahendran@mm-lab mahendran % 
```


## Unistalling JDK
We may have installed JDK using different ways. Meaning `manually` download dmg and install, via `brew install` command or via `brew cask install`
To see if it is installed using brew, use `brew list` command.
To view details about a package `brew info <package>` command

```
$ brew list
adoptopenjdk11  
$ brew info adoptopenjdk11
adoptopenjdk11: 11.0.9.1,1
https://adoptopenjdk.net/
/usr/local/Caskroom/adoptopenjdk11/11.0.5,10 (180.3MB)
From: https://github.com/adoptopenjdk/homebrew-openjdk/blob/HEAD/Casks/adoptopenjdk11.rb
==> Name
AdoptOpenJDK 11
==> Description
AdoptOpenJDK OpenJDK (Java) Development Kit
==> Artifacts
OpenJDK11U-jdk_x64_mac_hotspot_11.0.9.1_1.pkg (Pkg)
```


Once we know it is installed via brew, we can unistall using `brew uninstall <package>` command
```
$ brew uninstall adoptopenjdk
==> Uninstalling Cask adoptopenjdk
==> Removing directories if empty:
Warning: Skipping rmdir for undeletable path '/Library/Java/JavaVirtualMachines'.
==> Backing Generic Artifact 'adoptopenjdk-12.0.1.jdk' up to '/usr/local/Caskroom/adoptopenjdk/12.0.1,12/jdk-12.0.1+12'.
Password:
==> Removing Generic Artifact '/Library/Java/JavaVirtualMachines/adoptopenjdk-12.0.1.jdk'.
==> Purging files for version 12.0.1,12 of Cask adoptopenjdk
```

Uninstall will fail if any dependency on this package (formulae and casks) and you know what you are doing, you may need to force by ignoring dependencies
```
$ brew uninstall openjdk --ignore-dependencies
Uninstalling /usr/local/Cellar/openjdk/15.0.1... (614 files, 324.0MB)
```

## Next Reading Suggestion
Got multiple java version - [setup a quick way to switch between java version]({% link _posts/2021-11-14-switching-jdk-version-quickly.md %})


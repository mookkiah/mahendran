---
layout: post
title:  "Installing JDK on Mac"
date:   2021-11-14 06:55:00 -0400
categories: mac java
---

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


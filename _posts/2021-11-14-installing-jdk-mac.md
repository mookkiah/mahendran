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

## Next Reading Suggestion
Got multiple java version - [setup a quick way to switch between java version]({% link _posts/2021-11-14-switching-jdk-version-quickly %})


---
layout: post
title: "Developer setup - Windows"
date: 2021-01-01 15:15:00 -0400
modified_date: 
categories: developer windows
---

# Motivation
One of my friend asked me to help with a technical challenge. I was surprised with the way he had setup his machine with the tools needed for his development. Multiple tools for same purpose, multiple versions (really unnecessary minro versions) of the tools. Duplicates of git source code etc., I somehow managed to help made him happy first. Then asked these questions
- Does everybody on your team has the same setup as you?
    -   No, it depends what other project they involved.
- Do your company shared any instruction to organize tools, source code and project document so they can support?
    - No
- What if your hard disc corrupted, you need to set all these projects on new laptop?
    - Oh, NO. It will take time. I can setup the projects as and when needed. There is centralized backup if we store files in certain directories.
- What if I ask you to delete older version of tools (git, maven, java, eclipse) and have one as long as it supports your projects?
    - I can try. But I will do it later.

This is not new experience for me, we have been there. It is just the mindset of I am good for now. No one concerned about me struggling with my cumbersome setup.

Since I started my career, I happend to work in organized project teams where we had common setup across all developers. Those helped while helping, code review and conducting workshop in Extream Programming (XP).

Here I am sharing how I setup my windows laptop to keep it ready to use and having state of worry free about crashing.

## Backup
- Different companies have different backup strategies for user laptop. Some of them backup all while others backup certain directories (Ex: Documents) or certain drives (Mostly they exclude OS).


## Recommendation
- Understand System and User environment variables.
- Use commands so you can script and share it with others easily.
- Use portable/extractable instead of GUI based nstallation when it is available/supported by the provider.

## Organizing Directory Structure

- /Users/`<username>`/Documents --> Any non source code
- /Users/`<username>`/Git --> Top level directory for all projects from SCM. Keep the same directory structure as in your SCM (GitHub, GitLab). Example, If I checkout https://github.com/mookkiah/hop it will be under /Users/`<username>`/Git/mookkiah/hop
- Place all tools, libraries, applications under one standard folder. Example /Users/`<username>`/Applications


## Setup

### winget
Many application can be installed using Windows Package Manager `winget`. This is a command-line tool.

`winget` is bundled with Windows 11 and modern versions of Windows 10 by default as the App Installer.

https://learn.microsoft.com/en-us/windows/package-manager/winget/


### VS Code
```sh
winget install -e --id Microsoft.VisualStudioCode
```

### Git
```sh
winget install -e --id Git.Git
```

### Oracle JDK
```sh
winget install -e --id Oracle.JDK.17
```


## My Applications/Tools/Libraries list

- Git
- VS Code
- Eclipse STS
- JDK 11, 17
- Maven
- 

## Keep updated
It is good practice to keep the tooling upgraded to get the security fixes and use the new features which improves efficiency over the period of time and keep you stay ahead of the game.


## Exceptions
While standards good for most of the developers. There are experts who manages their computer by understanding underlying structure of projects tools they use with in the company. We welcome them to stay that way to innovate and contribute to the standard structure as and when they see solution to a complex procedure.

## References
- Installing JDK
- Switching JDK version
- Upgrading Git
- 


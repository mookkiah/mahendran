---
layout: post
title:  "Configuring Vi editor for better usability"
date:   2022-11-11 21:58:00 -0400
categories: unix editor
---

# Motivation
Everytime when we use vi editor, it is annoying that the keys is not working the way we expect.
It is becuase of default settings and ad-hoc user settings. Its good idea to have standard vi setting that works for all in shared accounts or our own user specific settings.

## Favoirite .vimrc
```
set nocompatible
set number
syntax on
set ruler
set tabstop=2
set shiftwidth=2
set autoindent
set smartindent
```

## Quick Commands
Sometimes we are in shared account, we should not change default settings with our own `.vimrc` to polute standards. But we can quickly enable the settings which we need at the time of needs.
Here are some example

`:set nu` - Show line numbers
`:set nocompatible` - To make the arrow keys to work

# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

"Mahendran's Notes" — a personal Jekyll blog of technical learnings, tips, and tricks. Built with the `minima` theme and published via GitHub Pages at the custom domain **mm-notes.com** (see `CNAME`). The repo is mostly Markdown content; there is almost no custom code.

## Commands

```bash
bundle install                  # install Ruby gem dependencies (first run / after Gemfile changes)
bundle exec jekyll serve        # local dev server with live reload at http://localhost:4000
bundle exec jekyll serve --drafts   # also render posts in _drafts/
bundle exec jekyll build        # build static site into _site/ (the .gitignore'd output)
```

There is no test/lint suite — content is the product. Deployment is automatic: pushing to the default branch triggers the GitHub Pages build. Note the `Gemfile` uses the standalone `jekyll` gem (4.3.x), not the `github-pages` gem, so the locally-installed Jekyll version can differ from what GitHub Pages runs.

### Serving without a local Ruby (Docker)

If Ruby/Bundler aren't installed, serve via a Ruby container. The committed `Gemfile.lock` is stale (pins jekyll 4.2.0 while the Gemfile wants ~> 4.3.1), so a plain `bundle install` fails — use `bundle update jekyll`. Copying the source into the container (instead of bind-mounting) keeps the working tree clean when bundler rewrites the lockfile:

```bash
docker run -d --name jekyll-notes -p 4000:4000 -w /site ruby:3.2 sleep infinity
docker cp "$PWD/." jekyll-notes:/site
docker exec -d jekyll-notes bash -lc \
  "gem install bundler -N && bundle update jekyll && bundle exec jekyll serve --host 0.0.0.0"
# site at http://localhost:4000/ ; tear down with: docker rm -f jekyll-notes
```

## Authoring posts

All posts live in `_posts/` and **must** follow Jekyll's filename convention `YYYY-MM-DD-title.md` or the post is silently dropped from the build. Each post starts with YAML front matter:

```yaml
---
layout: post
title:  "Human Readable Title"
date: 2024-09-05 3:58:00 -0400
modified_date: 2025-02-15 19:00:00 -0400   # optional, on edits
categories: aws tagging                    # space-separated tags
---
```

- `layout: post` for posts; `layout: page` (with a `permalink:`) for standalone pages like `about.markdown`.
- Images go in `assets/images/` (grouped in subfolders for image-heavy posts, e.g. `assets/images/rancher-desktop/`); downloadable files in `assets/files/`.
- Both `.md` and `.markdown` extensions are in use and both work.

## Site configuration

`_config.yml` holds site-wide settings (title, theme, `jekyll-feed` plugin, Google Analytics ID, social handles). Editing `_config.yml` requires restarting `jekyll serve` to take effect. The home page (`index.markdown`, `layout: home`) auto-lists posts via the minima theme. `_includes/google-analytics.html` overrides the theme's analytics partial.

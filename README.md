https://mookkiah.github.io/mahendran

https://dcc.godaddy.com/manage/mm-notes.com/dns
https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/managing-a-custom-domain-for-your-github-pages-site#

## Install instructions
```
git clone https://github.com/mookkiah/mahendran.git
cd mahendran
bundle install
bundle exec jekyll serve
```

## Preview locally with Docker (no Ruby needed)

If Ruby/Bundler aren't installed locally, use `preview.sh` to serve the site from a
`ruby:3.2` container. The source is copied into the container (not bind-mounted), so
bundler rewriting the stale `Gemfile.lock` never touches your working tree.

```bash
./preview.sh start      # create the container and serve at http://localhost:4000
./preview.sh logs       # follow the Jekyll build/serve output
./preview.sh sync       # copy local edits into the container (adds/updates only)
./preview.sh clean      # exact mirror: also drops deleted/renamed files, then re-serves
./preview.sh restart    # re-copy source and restart the server
./preview.sh stop       # stop serving but keep the container (fast restart)
./preview.sh status     # show whether the container is running
./preview.sh teardown   # stop and remove the container
```

The default host port is `4000`. Override it with the `PORT` env var or an argument to
`start` (`PORT=4005 ./preview.sh start` or `./preview.sh start 4005`); if that port is
already taken, the next free one is chosen automatically and printed. Use `status` to see
which port the running container is on.

Typical loop: `start` once, then `sync` after editing a post and refresh the browser.
Because `sync` only adds/updates files, after **renaming or deleting** a post use
`clean` instead — it wipes `/site` and re-copies so the container matches your working
tree exactly (gems live outside `/site`, so the wipe is safe). `.git` and the `_site`
build output are excluded from the copy to keep it fast.

The first `start` takes a minute or two while gems install; subsequent commands are quick.
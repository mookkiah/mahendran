#!/usr/bin/env bash
#
# preview.sh — serve the Jekyll site in a Docker container (no local Ruby needed).
#
# Usage:
#   ./preview.sh start [PORT]   Start the container and serve (default host port 4000)
#   ./preview.sh stop       Stop serving but keep the container (fast restart)
#   ./preview.sh restart    Stop, re-sync source, and serve again
#   ./preview.sh sync       Copy the current working tree into the running container (adds/updates only)
#   ./preview.sh clean      Mirror the working tree exactly — also removes deleted/renamed files, then re-serves
#   ./preview.sh logs       Follow the Jekyll build/serve logs
#   ./preview.sh status     Show whether the container is running
#   ./preview.sh teardown   Stop and remove the container entirely
#
# The host port can be set with the PORT env var or as the first argument to
# 'start' (e.g. 'PORT=4005 ./preview.sh start' or './preview.sh start 4005').
# If that port is already in use, the next free port is chosen automatically.
#
set -euo pipefail

NAME="jekyll-notes"
PORT="${PORT:-4000}"          # desired host port; may be overridden per-command
IMAGE="ruby:3.2"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

serve_cmd() {
  docker exec -d "$NAME" bash -lc \
    "gem install bundler -N && bundle update jekyll && bundle exec jekyll serve --host 0.0.0.0"
}

# True if the container exists at all (running or stopped).
container_exists() {
  docker ps -a --format '{{.Names}}' | grep -qx "$NAME"
}

# True if the container is currently running.
container_running() {
  docker ps --format '{{.Names}}' | grep -qx "$NAME"
}

# Ensure the container process is up before any 'docker exec'. A host reboot or
# Docker daemon restart kills the 'sleep infinity' PID 1, leaving the container
# stopped (exited 255) with its filesystem — source and installed gems — intact.
# 'docker start' revives it without a full re-copy/re-install. Returns 1 if no
# container exists at all (caller should run 'start').
ensure_up() {
  if container_running; then
    return 0
  elif container_exists; then
    echo "Container '$NAME' was stopped — starting it (gems/source preserved)..."
    docker start "$NAME" >/dev/null
  else
    return 1
  fi
}

# Copy the working tree into the container's /site, excluding .git (large, never
# needed) and _site (Jekyll's own build output, regenerated inside the container).
# Uses a tar pipe rather than 'docker cp' so we can exclude paths.
copy_in() {
  tar -C "$ROOT" --exclude='./.git' --exclude='./_site' -cf - . \
    | docker exec -i "$NAME" tar -C /site -xf -
}

# True if something is already listening on the given host port.
port_in_use() {
  (exec 3<>"/dev/tcp/127.0.0.1/$1") 2>/dev/null && { exec 3>&- 3<&-; return 0; }
  return 1
}

# Echo the first free host port at or after the given one (gives up after 50 tries).
pick_port() {
  local p="$1" tries=0
  while port_in_use "$p"; do
    p=$((p + 1)); tries=$((tries + 1))
    if [ "$tries" -ge 50 ]; then
      echo "No free port found near $1." >&2
      return 1
    fi
  done
  printf '%s' "$p"
}

# Echo the host port the running container actually publishes (empty if stopped).
container_port() {
  docker port "$NAME" 4000/tcp 2>/dev/null | head -n1 | sed 's/.*://'
}

# True if a Jekyll serve process is alive inside the container. The container
# itself runs 'sleep infinity', so it stays up across 'stop' — this is what
# distinguishes "serving" from merely "container exists".
serve_running() {
  docker exec "$NAME" bash -lc "pgrep -f '[j]ekyll' >/dev/null 2>&1"
}

case "${1:-}" in
  start)
    if docker ps -a --format '{{.Names}}' | grep -qx "$NAME"; then
      echo "Container '$NAME' already exists. Use 'restart' or 'teardown' first."
      exit 1
    fi
    desired="${2:-$PORT}"
    host_port="$(pick_port "$desired")"
    if [ "$host_port" != "$desired" ]; then
      echo "Port $desired is in use — using $host_port instead."
    fi
    echo "Starting container..."
    docker run -d --name "$NAME" -p "$host_port:4000" -w /site "$IMAGE" sleep infinity >/dev/null
    echo "Copying site source in..."
    copy_in
    echo "Installing gems and serving (first run takes a minute or two)..."
    serve_cmd
    echo "Serving at http://localhost:$host_port/  —  run './preview.sh logs' to watch the build."
    ;;

  sync)
    copy_in
    echo "Source synced into container."
    ;;

  clean)
    # docker cp only adds/updates files; it never deletes. After a rename or
    # deletion that leaves a stale copy behind (e.g. a duplicate post), wipe
    # /site and re-copy so the container mirrors the working tree exactly.
    # Gems live in /usr/local/bundle (outside /site), so the wipe is safe; the
    # re-serve runs 'bundle update jekyll', regenerating the removed lockfile.
    echo "Stopping serve and wiping /site..."
    # '[j]ekyll' so this pkill does not match its own command line (which would
    # SIGTERM this very shell before 'find' runs).
    docker exec "$NAME" bash -lc "pkill -f '[j]ekyll' || true; find /site -mindepth 1 -delete"
    echo "Copying fresh source in..."
    copy_in
    serve_cmd
    echo "Clean sync done. Re-serving at http://localhost:$(container_port)/  —  run './preview.sh logs' to watch the build."
    ;;

  restart)
    if ! ensure_up; then
      echo "No container named '$NAME'. Use 'start' first."
      exit 1
    fi
    docker exec "$NAME" bash -lc "pkill -f '[j]ekyll' || true"
    copy_in
    serve_cmd
    echo "Re-serving at http://localhost:$(container_port)/"
    ;;

  stop)
    docker exec "$NAME" bash -lc "pkill -f '[j]ekyll' || true"
    echo "Stopped serving (container kept). Use 'restart' to serve again."
    ;;

  logs)
    docker exec "$NAME" bash -lc "tail -f /site/.jekyll-serve.log 2>/dev/null" 2>/dev/null \
      || docker logs -f "$NAME"
    ;;

  status)
    if docker ps --format '{{.Names}}' | grep -qx "$NAME"; then
      if serve_running; then
        echo "Container '$NAME' is serving at http://localhost:$(container_port)/"
      else
        echo "Container '$NAME' is up but Jekyll is not serving. Use 'restart' to serve again."
      fi
    elif docker ps -a --format '{{.Names}}' | grep -qx "$NAME"; then
      echo "Container '$NAME' exists but is stopped. Use 'restart' to revive it."
    else
      echo "No container named '$NAME'."
    fi
    ;;

  teardown)
    docker rm -f "$NAME" >/dev/null 2>&1 && echo "Removed container '$NAME'." \
      || echo "No container '$NAME' to remove."
    ;;

  *)
    echo "Usage: ./preview.sh {start [PORT]|stop|restart|sync|clean|logs|status|teardown}"
    exit 1
    ;;
esac

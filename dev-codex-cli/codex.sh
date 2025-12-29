#!/bin/sh
set -eu

if ! command -v docker >/dev/null 2>&1; then
  echo "Docker is required but was not found."
  exit 1
fi

CODEX_HOME_DIR="${CODEX_HOME:-$HOME/.codex}"
ENV_OPT=""

if [ -f "./.env" ]; then
  ENV_OPT="--env-file ./.env"
fi

exec docker run --rm -it \
  $ENV_OPT \
  -v "$(realpath "$CODEX_HOME_DIR"):/root/.codex" \
  -v "$(realpath ./):/workspace" \
  -v "$(realpath ~/.gitconfig):/root/.gitconfig" \
  -p 5598:5598 \
  -p 1455:1455 \
  m4tchl0ck/dev-codex-cli:latest

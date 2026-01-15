#!/bin/sh
set -e

if command -v dev-setup >/dev/null 2>&1; then
  DEV_SETUP_NO_SHELL=1 dev-setup
fi

exec run-codex "$@"

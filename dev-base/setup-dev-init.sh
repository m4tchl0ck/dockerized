#!/bin/sh

# Only run in an interactive shell. Derived image builds use `zsh -lc` (a
# login but non-interactive shell), which would otherwise run setup-dev — and
# its `gh auth login` device prompt — on the first RUN of every Dockerfile.
case $- in
  *i*) ;;
  *) return 0 2>/dev/null || exit 0 ;;
esac

if [ ! -f "$HOME/.setup-dev-done" ]; then
    setup-dev
    touch "$HOME/.setup-dev-done"
fi

#!/bin/sh

if [ ! -f "$HOME/.setup-dev-done" ]; then
    setup-dev
    touch "$HOME/.setup-dev-done"
fi

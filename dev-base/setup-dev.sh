#!/bin/sh

if ! gh auth status >/dev/null 2>&1; then
  gh auth login
fi

if command -v chezmoi >/dev/null 2>&1; then
  printf "Initialize dotfiles with chezmoi? [y/N]: "
  read -r chezmoi_answer
  case "$chezmoi_answer" in
  y | Y | yes | YES)
    printf "Enter dotfiles repo URL: "
    read -r dotfiles_repo
    if [ -n "$dotfiles_repo" ]; then
      chezmoi init --apply "$dotfiles_repo"
    fi
    ;;
  esac
else
  echo "chezmoi is not installed."
fi

printf "Install AI tools? [y/N]: "
read -r ai_answer
case "$ai_answer" in
y | Y | yes | YES)
    printf "Installing mcp-remote"
    printf "---------------------"
    npm install -g mcp-remote
    printf "---------------------"
    printf "mcp-remote installed"

    printf "Installing @openai/codex"
    printf "---------------------"
    npm install -g @openai/codex
    printf "---------------------"
    printf "@openai/codex installed"

    printf "Installing OpenCode"
    printf "---------------------"
    curl -fsSL https://opencode.ai/install | bash
    printf "---------------------"
    printf "OpenCode installed"

    printf "Installing ClaudeCode"
    printf "---------------------"
    curl -fsSL https://claude.ai/install.sh | bash
    printf "---------------------"
    printf "ClaudeCode installed"
  ;;
esac

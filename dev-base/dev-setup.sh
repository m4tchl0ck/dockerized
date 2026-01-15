#!/bin/sh

if ! gh auth status >/dev/null 2>&1; then
  gh auth login
fi

if ! command -v chezmoi >/dev/null 2>&1; then
  printf "Initialize dotfiles with chezmoi? [y/N]: "
  read -r chezmoi_answer
  case "$chezmoi_answer" in
    y|Y|yes|YES)
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

zsh

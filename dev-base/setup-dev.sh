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
      zsh
    fi
    ;;
  esac
else
  echo "chezmoi is not installed."
fi

printf "Install rtk? [y/N]: "
read -r rtk_answer
case "$rtk_answer" in
y | Y | yes | YES)
    curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh \
    && echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc \
    && echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
    rtk init -g
  ;;
esac

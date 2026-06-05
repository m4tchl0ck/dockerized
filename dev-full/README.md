# dev-base

Base development container built on Alpine Linux with a minimal, fast CLI stack.

## Included tools
- zsh as the default shell
- curl, wget, ca-certificates
- GitHub CLI and GnuPG
- bat, btop, eza, fzf, jless, jq, ripgrep
- Neovim with LazyVim starter preloaded
- chezmoi installer (adds to PATH via .zshrc)

## Entrypoint
The container starts `dev-setup`, which:
- checks GitHub CLI auth and runs `gh auth login` if needed
- optionally initializes dotfiles with chezmoi
- launches zsh

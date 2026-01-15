# dev-codex-cli

Container for OpenAI Codex CLI, built on `dev-typescript`.

## Included tools
- `@openai/codex` installed globally with npm
- `mcp-remote` installed globally with npm
- zsh set as the default shell

## Entrypoint
The container starts `entrypoint`, which:
- runs `dev-setup` to handle GitHub CLI auth and optional dotfiles setup
- launches `run-codex` to select or start a Codex session

`run-codex` lists saved sessions from `$CODEX_HOME/sessions`, then runs `codex` or `codex resume` accordingly.

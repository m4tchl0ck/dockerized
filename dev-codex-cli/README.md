# dev-codex-cli

Container for OpenAI Codex CLI, built on `dev-typescript`.

## Included tools
- `@openai/codex` installed globally with npm
- `mcp-remote` installed globally with npm
- zsh set as the default shell

## Entrypoint
The container starts `run-codex`, which:
- lists saved sessions from `$CODEX_HOME/sessions`
- allows selecting or starting a new session
- runs `codex` or `codex resume` accordingly

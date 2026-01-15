# Dockerized tools

Set of tools customised and dockerised.

| Container | Description |
| --- | --- |
| [dev-base](dev-base/README.md) | Base Alpine container with a minimal, fast CLI stack usable for development |
| [dev-dotnet](dev-dotnet/README.md) | Development container for .NET built on dev-base. Installs the .NET SDK via Alpine packages. |
| [dev-node](dev-node/README.md) | Development container for Node.js built on dev-base. Installs Node.js and npm via apk. |
| [dev-typescript](dev-typescript/README.md) | TypeScript/Node container based on the Microsoft devcontainers image. Adds zsh, GitHub CLI, and GnuPG utilities. |
| [dev-codex-cli](dev-codex-cli/README.md) | Container for OpenAI Codex CLI built on dev-typescript. Uses the run-codex entrypoint to select or start sessions. |

# Dockerized tools

Set of tools customised and dockerised.

| Container | Description |
| --- | --- |
| [dev-base](dev-base/README.md) | Base Debian container with a minimal, fast CLI stack usable for development |
| [dev-dotnet](dev-dotnet/README.md) | Development container for .NET built on dev-base. Installs the .NET SDK via the Microsoft apt repo. |
| [dev-node](dev-node/README.md) | Development container for Node.js built on dev-base. Installs Node.js LTS via NodeSource. |
| [dev-typescript](dev-typescript/README.md) | TypeScript container built on dev-node. Adds TypeScript, ts-node, and tsx globally. |
| [dev-python](dev-python) | Development container for Python built on dev-base. Installs Python 3 with pip and venv. |
| [dev-ai](dev-ai) | AI CLI tools container built on dev-base. Includes Claude Code, OpenAI Codex, opencode, and mcp-remote. |
| [dev-full](dev-full) | All-in-one container built on dev-base. Combines dev-dotnet, dev-node, dev-typescript, dev-python, and dev-ai. |

## Creating a new workspace

`create-workspace.sh` scaffolds a new VS Code devcontainer workspace from the template in `workspace/`.

```sh
./create-workspace.sh <name> [target-dir]
```

- `name` — workspace name, used in `devcontainer.json` and as the mount path under `~/dev-containers/`
- `target-dir` — where to create the workspace directory (default: current directory)

**What it does:**

1. Downloads `.devcontainer/Dockerfile`, `docker-compose.yaml`, and `devcontainer.json` from the `workspace/` template
2. Substitutes the workspace name into `devcontainer.json`
3. Creates `~/dev-containers/<name>/home` — the bind-mount that becomes `/home/vscode` inside the container

**Examples:**

```sh
./create-workspace.sh my-project
./create-workspace.sh my-project ~/repos
```

Then open the resulting directory in VS Code and reopen in container.

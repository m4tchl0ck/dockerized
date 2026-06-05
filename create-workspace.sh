#!/bin/sh
set -eu

REPO="m4tchl0ck/dockerized"
BRANCH="main"
TEMPLATE_PATH="workspace"
RAW_BASE="https://raw.githubusercontent.com/$REPO/$BRANCH/$TEMPLATE_PATH"

TEMPLATE_FILES="
.devcontainer/Dockerfile
.devcontainer/docker-compose.yaml
.devcontainer/devcontainer.json
"

usage() {
  cat <<'USAGE'
Usage: create-workspace.sh <name> [target-dir]

Creates a new workspace from the template with the given name.

Arguments:
  name        Workspace name (used in devcontainer.json and mount path)
  target-dir  Directory to create the workspace in (default: current directory)

Examples:
  curl -fsSL https://raw.githubusercontent.com/m4tchl0ck/dockerized/main/create-workspace.sh | sh -s -- my-project
  curl -fsSL https://raw.githubusercontent.com/m4tchl0ck/dockerized/main/create-workspace.sh | sh -s -- my-project ~/repos
USAGE
}

if [ "$#" -lt 1 ]; then
  usage
  exit 1
fi

NAME="$1"
TARGET_DIR="${2:-.}/$NAME"

if [ -e "$TARGET_DIR" ]; then
  echo "Error: '$TARGET_DIR' already exists." >&2
  exit 1
fi

echo "Creating workspace '$NAME' at: $TARGET_DIR"

for FILE in $TEMPLATE_FILES; do
  DEST="$TARGET_DIR/$FILE"
  mkdir -p "$(dirname "$DEST")"
  curl -fsSL "$RAW_BASE/$FILE" -o "$DEST"
done

# Substitute name and mount path in devcontainer.json
DEVCONTAINER="$TARGET_DIR/.devcontainer/devcontainer.json"

sed -i.bak \
  -e "s|\"name\": \"Workspace\"|\"name\": \"$NAME\"|g" \
  -e "s|dev-containers/workspace|dev-containers/$NAME|g" \
  "$DEVCONTAINER"

rm "$DEVCONTAINER.bak"

echo "Done. Open '$TARGET_DIR' in VS Code to start."

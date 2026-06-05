#!/bin/sh
set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR/workspace"

usage() {
  cat <<'USAGE'
Usage: create-workspace.sh <name> [target-dir]

Creates a new workspace from the template with the given name.

Arguments:
  name        Workspace name (used in devcontainer.json and mount path)
  target-dir  Directory to create the workspace in (default: current directory)
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

cp -r "$TEMPLATE_DIR" "$TARGET_DIR"

# Substitute name and mount path in devcontainer.json
DEVCONTAINER="$TARGET_DIR/.devcontainer/devcontainer.json"

sed -i.bak \
  -e "s|\"name\": \"Workspace\"|\"name\": \"$NAME\"|g" \
  -e "s|dev-containers/workspace/home|dev-containers/$NAME/home|g" \
  "$DEVCONTAINER"

rm "$DEVCONTAINER.bak"

echo "Workspace '$NAME' created at: $TARGET_DIR"

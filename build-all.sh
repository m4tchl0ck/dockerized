#!/bin/sh
set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

usage() {
  cat <<'USAGE'
Usage: build-all.sh <version> [options]

Options:
  --push           Push multi-arch images to registry (default).
  --load           Load single-arch image into local Docker daemon.
  --platforms P    Platform list (default: linux/amd64,linux/arm64).
  --registry R     Registry/namespace prefix (default: m4tchl0ck).
  -h, --help       Show this help.
USAGE
}

if [ "$#" -lt 1 ]; then
  usage
  exit 1
fi

VERSION="$1"
shift

EXTRA_ARGS=""

while [ "$#" -gt 0 ]; do
  case "$1" in
    --push|--load)
      EXTRA_ARGS="$EXTRA_ARGS $1"
      ;;
    --platforms|--registry)
      EXTRA_ARGS="$EXTRA_ARGS $1 $2"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage
      exit 1
      ;;
  esac
  shift
done

build() {
  echo ""
  echo "==> Building $1..."
  # shellcheck disable=SC2086
  "$SCRIPT_DIR/build-container.sh" "$1" "$VERSION" $EXTRA_ARGS
}

# Layer 1: base
build dev-base

# Layer 2: depend on dev-base
build dev-node
build dev-dotnet
build dev-python
build dev-ai
build dev-full

# Layer 3: depend on dev-node
build dev-typescript

echo ""
echo "All containers built and published successfully."

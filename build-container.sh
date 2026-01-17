#!/bin/sh
set -eu

usage() {
  cat <<'USAGE'
Usage: build-container.sh <container> <version> [options]

Options:
  --push           Push the multi-arch image (default).
  --load           Load the image into the local Docker daemon (single platform only).
  --platforms P    Platform list (default: linux/amd64,linux/arm64).
  --registry R     Registry/namespace prefix (default: m4tchl0ck).
  --context DIR    Build context directory (default: <container>).
  --dockerfile F   Dockerfile path (default: <context>/Dockerfile).
  -h, --help       Show this help.
USAGE
}

if [ "$#" -lt 2 ]; then
  usage
  exit 1
fi

CONTAINER="$1"
VERSION="$2"
shift 2

PLATFORMS="linux/amd64,linux/arm64"
REGISTRY_PREFIX="m4tchl0ck"
CONTEXT_DIR="$CONTAINER"
DOCKERFILE="$CONTEXT_DIR/Dockerfile"
BUILD_FLAG="--push"

while [ "$#" -gt 0 ]; do
  case "$1" in
    --push)
      BUILD_FLAG="--push"
      ;;
    --load)
      BUILD_FLAG="--load"
      ;;
    --platforms)
      PLATFORMS="$2"
      shift
      ;;
    --registry)
      REGISTRY_PREFIX="$2"
      shift
      ;;
    --context)
      CONTEXT_DIR="$2"
      shift
      ;;
    --dockerfile)
      DOCKERFILE="$2"
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

if [ ! -d "$CONTEXT_DIR" ]; then
  echo "Build context directory not found: $CONTEXT_DIR" >&2
  exit 1
fi

if [ ! -f "$DOCKERFILE" ]; then
  echo "Dockerfile not found: $DOCKERFILE" >&2
  exit 1
fi

case "$PLATFORMS" in
  *,*)
    if [ "$BUILD_FLAG" = "--load" ]; then
      echo "--load only supports a single platform; use --platforms linux/amd64 or linux/arm64." >&2
      exit 1
    fi
    ;;
  *)
    ;;
esac

IMAGE_BASE="$REGISTRY_PREFIX/$CONTAINER"

echo "Building $IMAGE_BASE:latest and $IMAGE_BASE:$VERSION for $PLATFORMS with context $CONTEXT_DIR and flags $BUILD_FLAG"
exec docker buildx build \
  --platform "$PLATFORMS" \
  -t "$IMAGE_BASE:latest" \
  -t "$IMAGE_BASE:$VERSION" \
  -f "$DOCKERFILE" \
  "$BUILD_FLAG" \
  "$CONTEXT_DIR"

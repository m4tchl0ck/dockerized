#!/bin/sh
set -eu

new_session() {
  codex -a on-request -C /workspace --sandbox workspace-write "$@"
}

CODEX_HOME_DIR="${CODEX_HOME:-$HOME/.codex}"
SESS_DIR="$CODEX_HOME_DIR/sessions"

if [ ! -d "$SESS_DIR" ]; then
  echo "No sessions directory found: $SESS_DIR"
  echo "Starting a new session."
  new_session "$@"
fi

list_sessions() {
  find "$SESS_DIR" -type f -name "*.jsonl" -print | sort
}

SESSIONS="$(list_sessions || true)"
if [ -z "$SESSIONS" ]; then
  echo "No saved sessions found."
  echo "Starting a new session."
  new_session "$@"
fi

echo "Available sessions:"

idx=1
for path in $SESSIONS; do
  s="$(basename "$path")"
  display="$(printf '%s' "$s" | sed -n 's/^rollout-\([0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}\)T\([0-9]\{2\}\)-\([0-9]\{2\}\)-\([0-9]\{2\}\)-\([0-9A-Fa-f-]\{36\}\)\.jsonl$/\1 \2:\3:\4 \5/p')"
  if [ -n "$display" ]; then
    echo "  $idx) $display"
  else
    echo "  $idx) $s"
  fi
  idx=$((idx + 1))
done
echo "  N) new session"
echo "  Q) quit"

printf "Select [N]: "
read -r choice
choice="${choice:-N}"

case "$choice" in
  N|n)
    new_session "$@"
    exit 0
    ;;
  Q|q)
    echo "Done."
    exit 0
    ;;
  *)
    if [ "$choice" -ge 1 ] 2>/dev/null; then
      sel=1
      for path in $SESSIONS; do
        s="$(basename "$path")"
        if [ "$sel" -eq "$choice" ]; then
          session_id="$(printf '%s' "$s" | sed -n 's/.*-\([0-9A-Fa-f]\{8\}-[0-9A-Fa-f]\{4\}-[0-9A-Fa-f]\{4\}-[0-9A-Fa-f]\{4\}-[0-9A-Fa-f]\{12\}\)\.jsonl$/\1/p')"
          if [ -n "$session_id" ]; then
            echo "Resuming session: $session_id"
            codex resume "$session_id" "$@"
          else
            echo "Could not extract UUID from session file name: $s"
          fi
        fi
        sel=$((sel + 1))
      done
      exit 0
    fi
    echo "Invalid selection."
    exit 1
    ;;
esac

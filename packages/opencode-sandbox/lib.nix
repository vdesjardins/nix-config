# Helper functions for opencode-sandbox
# This file provides shell script utilities for overlay setup, process tracking, and cleanup
{
  bubblewrap,
  coreutils,
  jq,
  util-linux,
  zsh,
}: {
  # Generate a unique sandbox ID using uuidgen
  generate-sandbox-id = ''
    ${coreutils}/bin/uuidgen | ${coreutils}/bin/tr -d '-'
  '';

  # Get XDG cache home, default to ~/.cache if not set
  get-xdg-cache-home = ''
    if [ -z "''${XDG_CACHE_HOME}" ]; then
      echo "''${HOME}/.cache"
    else
      echo "''${XDG_CACHE_HOME}"
    fi
  '';

  # Check if a process is alive
  # Usage: check-is-alive <PID>
  check-is-alive = ''
    PID=$1
    if [ -z "$PID" ]; then
      echo "error: PID required" >&2
      exit 1
    fi

    if kill -0 "$PID" 2>/dev/null; then
      echo "running"
    else
      echo "exited"
    fi
  '';

  # Write sandbox metadata JSON file
  # Usage: write-metadata <SANDBOX_DIR> <ID> <PID>
  write-metadata = ''
    SANDBOX_DIR=$1
    ID=$2
    PID=$3

    if [ -z "$SANDBOX_DIR" ] || [ -z "$ID" ] || [ -z "$PID" ]; then
      echo "error: SANDBOX_DIR, ID, and PID required" >&2
      exit 1
    fi

    CREATED_AT=$(${coreutils}/bin/date -u +"%Y-%m-%dT%H:%M:%SZ")

    ${jq}/bin/jq -n \
      --arg id "$ID" \
      --arg created_at "$CREATED_AT" \
      --arg pid "$PID" \
      --arg status "running" \
      '{id: $id, created_at: $created_at, pid: $pid, status: $status}' \
      > "$SANDBOX_DIR/.metadata"
  '';

  # Create overlayfs mount for /nix/store
  # Usage: create-nix-store-overlay <SANDBOX_ID> <CACHE_DIR>
  # Output: Path to merged directory
  create-nix-store-overlay = ''
    SANDBOX_ID=$1
    CACHE_DIR=$2

    if [ -z "$SANDBOX_ID" ] || [ -z "$CACHE_DIR" ]; then
      echo "error: SANDBOX_ID and CACHE_DIR required" >&2
      exit 1
    fi

    SANDBOX_DIR="$CACHE_DIR/opencode/sandboxes/$SANDBOX_ID"
    UPPER_DIR="$SANDBOX_DIR/nix-store-changes"
    WORK_DIR="$SANDBOX_DIR/nix-store-work"
    MERGED_DIR="/tmp/.opencode-$SANDBOX_ID/nix-store"

    # Create necessary directories
    ${coreutils}/bin/mkdir -p "$UPPER_DIR"
    ${coreutils}/bin/mkdir -p "$WORK_DIR"
    ${coreutils}/bin/mkdir -p "$MERGED_DIR"

    # Create overlayfs mount
    if ! ${util-linux}/bin/mount -t overlay overlay \
      -o lowerdir=/nix/store,upperdir="$UPPER_DIR",workdir="$WORK_DIR" \
      "$MERGED_DIR" 2>/dev/null; then
      echo "error: Failed to mount overlayfs for /nix/store" >&2
      exit 1
    fi

    echo "$MERGED_DIR"
  '';

  # Create overlayfs mount for home directory
  # Usage: create-home-overlay <SANDBOX_ID> <CACHE_DIR> <HOME_DIR>
  # Output: Path to merged directory
  create-home-overlay = ''
    SANDBOX_ID=$1
    CACHE_DIR=$2
    HOME_DIR=$3

    if [ -z "$SANDBOX_ID" ] || [ -z "$CACHE_DIR" ] || [ -z "$HOME_DIR" ]; then
      echo "error: SANDBOX_ID, CACHE_DIR, and HOME_DIR required" >&2
      exit 1
    fi

    SANDBOX_DIR="$CACHE_DIR/opencode/sandboxes/$SANDBOX_ID"
    UPPER_DIR="$SANDBOX_DIR/home-changes"
    WORK_DIR="$SANDBOX_DIR/home-work"
    MERGED_DIR="/tmp/.opencode-$SANDBOX_ID/home"

    # Create necessary directories
    ${coreutils}/bin/mkdir -p "$UPPER_DIR"
    ${coreutils}/bin/mkdir -p "$WORK_DIR"
    ${coreutils}/bin/mkdir -p "$MERGED_DIR"

    # Create overlayfs mount
    if ! ${util-linux}/bin/mount -t overlay overlay \
      -o lowerdir="$HOME_DIR",upperdir="$UPPER_DIR",workdir="$WORK_DIR" \
      "$MERGED_DIR" 2>/dev/null; then
      echo "error: Failed to mount overlayfs for home directory" >&2
      exit 1
    fi

    echo "$MERGED_DIR"
  '';

  # Cleanup old sandboxes (older than 7 days and not running)
  # Usage: cleanup-old-sandboxes [CACHE_DIR]
  cleanup-old-sandboxes = ''
    CACHE_DIR=$1
    if [ -z "$CACHE_DIR" ]; then
      CACHE_DIR=$(${coreutils}/bin/printenv XDG_CACHE_HOME)
      if [ -z "$CACHE_DIR" ]; then
        CACHE_DIR="$HOME/.cache"
      fi
    fi

    SANDBOX_BASE="$CACHE_DIR/opencode/sandboxes"
    if [ ! -d "$SANDBOX_BASE" ]; then
      exit 0
    fi

    CURRENT_TIME=$(${coreutils}/bin/date +%s)
    SEVEN_DAYS=$((7 * 24 * 60 * 60))

    # Iterate through sandboxes
    for sandbox_dir in "$SANDBOX_BASE"/*; do
      if [ ! -d "$sandbox_dir" ]; then
        continue
      fi

      if [ ! -f "$sandbox_dir/.metadata" ]; then
        continue
      fi

      # Check if sandbox is running
      PID=$(${jq}/bin/jq -r '.pid' "$sandbox_dir/.metadata" 2>/dev/null)
      if [ -n "$PID" ] && kill -0 "$PID" 2>/dev/null; then
        # Sandbox is still running, skip
        continue
      fi

      # Get creation time and check if older than 7 days
      CREATED_AT=$(${jq}/bin/jq -r '.created_at' "$sandbox_dir/.metadata" 2>/dev/null)
      CREATED_TIME=$(${coreutils}/bin/date -d "$CREATED_AT" +%s 2>/dev/null || echo 0)
      AGE=$((CURRENT_TIME - CREATED_TIME))

      if [ $AGE -gt $SEVEN_DAYS ]; then
        # Remove sandbox directory
        ${coreutils}/bin/rm -rf "$sandbox_dir"
      fi
    done
  '';

  # Get store changes size for a sandbox
  # Usage: get-store-changes-size <SANDBOX_DIR>
  get-store-changes-size = ''
    SANDBOX_DIR=$1
    if [ -z "$SANDBOX_DIR" ]; then
      echo "error: SANDBOX_DIR required" >&2
      exit 1
    fi

    CHANGES_DIR="$SANDBOX_DIR/nix-store-changes"
    if [ ! -d "$CHANGES_DIR" ]; then
      echo "0"
      exit 0
    fi

    ${util-linux}/bin/du -sh "$CHANGES_DIR" | ${coreutils}/bin/awk '{print $1}'
  '';
}

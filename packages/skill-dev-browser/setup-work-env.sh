#!/bin/bash

# Shared environment setup for dev-browser wrapper scripts
# Sources this file from wrapper scripts: source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/setup-work-env.sh"
# Provides: $WORK_DIR, proper PATH, environment variables

# Create temp directory with automatic cleanup on exit
WORK_DIR=$(mktemp -d)
# shellcheck disable=SC2064
trap "rm -rf $WORK_DIR" EXIT

# Get the directory of the calling script (parent of setup-work-env.sh)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[1]}")" && pwd)"

# Dynamically symlink all content from source directory
# Excludes wrapper scripts to prevent recursion
for item in "$SCRIPT_DIR"/*; do
	filename=$(basename "$item")
	# Skip wrapper scripts and this setup script itself
	if [[ ! $filename =~ ^(server\.sh|start-extension\.sh|run-script\.sh|setup-work-env\.sh)$ ]]; then
		ln -s "$item" "$WORK_DIR/$filename"
	fi
done

# Create writable directories that scripts expect to write to
mkdir -p "$WORK_DIR/tmp" "$WORK_DIR/profiles"

# Export paths to writable directories so TypeScript code can use them
export DEV_BROWSER_TMP_DIR="$WORK_DIR/tmp"
export DEV_BROWSER_PROFILES_DIR="$WORK_DIR/profiles"

# Set up Node.js environment for npm/npx to work
export PATH="@nodejs@/bin:$PATH"

# Point Playwright to the Nix-packaged Chromium instead of trying to download
export PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1
export CHROMIUM_PATH="@chromium@/bin/chromium"

# Change to the isolated working directory
cd "$WORK_DIR" || exit

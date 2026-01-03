#!/bin/bash

set -o pipefail

# Debug logging utility (defined early, before setup)
_debug() {
	if [[ ${DEV_BROWSER_DEBUG:-0} == "1" ]]; then
		echo "[dev-browser:run-script] DEBUG: $*" >&2
	fi
}

_info() {
	echo "[dev-browser:run-script] INFO: $*" >&2
}

_error() {
	echo "[dev-browser:run-script] ERROR: $*" >&2
}

# Source shared setup function
# shellcheck source=setup-work-env.sh disable=SC1091
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/setup-work-env.sh"

_debug "Work directory: $WORK_DIR"
_debug "NODE.js PATH set: @nodejs@/bin"
_debug "Playwright configured to use Chromium: @chromium@/bin/chromium"
_debug "Executing: @nodejs@/bin/npx tsx $*"

# Run npx tsx with all arguments passed through
@nodejs@/bin/npx tsx "$@"

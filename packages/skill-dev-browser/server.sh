#!/bin/bash

# Source shared setup function
# shellcheck source=setup-work-env.sh disable=SC1091
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/setup-work-env.sh"

# Parse command line arguments
HEADLESS=false
while [[ $# -gt 0 ]]; do
	case $1 in
	--headless) HEADLESS=true ;;
	*)
		echo "Unknown parameter: $1"
		exit 1
		;;
	esac
	shift
done

echo "Starting dev-browser server..."
export HEADLESS=$HEADLESS
npx tsx scripts/start-server.ts

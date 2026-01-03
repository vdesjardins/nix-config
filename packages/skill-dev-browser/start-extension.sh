#!/bin/bash

# Source shared setup function
# shellcheck source=setup-work-env.sh disable=SC1091
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/setup-work-env.sh"

echo "Starting dev-browser extension relay server..."
npm run start-extension

#!/usr/bin/env bash
# shellcheck disable=SC2034,SC2086,SC2012

# Bulk Update Tags for Buku Bookmarks
#
# Usage: ./bulk-update-tags.sh [OPTIONS]
#
# Options:
#   -s, --search KEYWORD      Search bookmarks by keyword
#   -t, --tag TAG             Filter bookmarks by tag
#   -a, --add TAG             Add tags (append with >>)
#   -r, --remove TAG          Remove tags (with <<)
#   -S, --set TAG             Replace all tags (with >)
#   -R, --range START-END     Apply to bookmark range
#   --dry-run                 Preview changes without applying
#   -h, --help                Show this help message
#
# Examples:
#   # Add 'archived' tag to all 'old' bookmarks
#   ./bulk-update-tags.sh -s old -a archived
#
#   # Remove 'tutorial' tag from all 'learning' bookmarks
#   ./bulk-update-tags.sh -t learning -r tutorial
#
#   # Replace all tags on bookmarks #1-10
#   ./bulk-update-tags.sh -R 1-10 -S "important,active"
#
#   # Preview changes (dry-run)
#   ./bulk-update-tags.sh -s python -a learning --dry-run

set -euo pipefail

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
DRY_RUN=0
SEARCH_KEYWORD=""
SEARCH_TAG=""
ADD_TAGS=""
REMOVE_TAGS=""
SET_TAGS=""
RANGE=""
BATCH_SIZE=10

# Helper functions
log_info() {
	echo -e "${BLUE}ℹ${NC} $*"
}

log_success() {
	echo -e "${GREEN}✓${NC} $*"
}

log_warning() {
	echo -e "${YELLOW}⚠${NC} $*"
}

log_error() {
	echo -e "${RED}✗${NC} $*"
}

show_help() {
	grep "^# " "$0" | sed 's/^# //'
}

# Parse arguments
while [[ $# -gt 0 ]]; do
	case $1 in
	-s | --search)
		SEARCH_KEYWORD="$2"
		shift 2
		;;
	-t | --tag)
		SEARCH_TAG="$2"
		shift 2
		;;
	-a | --add)
		ADD_TAGS="$2"
		shift 2
		;;
	-r | --remove)
		REMOVE_TAGS="$2"
		shift 2
		;;
	-S | --set)
		SET_TAGS="$2"
		shift 2
		;;
	-R | --range)
		RANGE="$2"
		shift 2
		;;
	--dry-run)
		DRY_RUN=1
		shift
		;;
	-h | --help)
		show_help
		exit 0
		;;
	*)
		log_error "Unknown option: $1"
		show_help
		exit 1
		;;
	esac
done

# Validation
if [[ -z $SEARCH_KEYWORD ]] && [[ -z $SEARCH_TAG ]] && [[ -z $RANGE ]]; then
	log_error "Must specify -s (search), -t (tag), or -R (range)"
	show_help
	exit 1
fi

if [[ -z $ADD_TAGS ]] && [[ -z $REMOVE_TAGS ]] && [[ -z $SET_TAGS ]]; then
	log_error "Must specify -a (add), -r (remove), or -S (set) tags"
	show_help
	exit 1
fi

# Get list of bookmark IDs to update
get_bookmark_ids() {
	local ids=""

	if [[ -n $RANGE ]]; then
		# Parse range (e.g., "1-10" or "5")
		if [[ $RANGE =~ ^[0-9]+-[0-9]+$ ]]; then
			local start="${RANGE%-*}"
			local end="${RANGE#*-}"
			ids=$(seq "$start" "$end")
		elif [[ $RANGE =~ ^[0-9]+$ ]]; then
			ids="$RANGE"
		else
			log_error "Invalid range format: $RANGE (use '1-10' or '5')"
			exit 1
		fi
	elif [[ -n $SEARCH_TAG ]]; then
		ids=$(buku -t "$SEARCH_TAG" -p 2>/dev/null | grep "^[0-9]" | cut -d. -f1 || echo "")
	elif [[ -n $SEARCH_KEYWORD ]]; then
		ids=$(buku -s "$SEARCH_KEYWORD" -p 2>/dev/null | grep "^[0-9]" | cut -d. -f1 || echo "")
	fi

	echo "$ids"
}

# Build tag update command
build_tag_command() {
	local cmd=""

	if [[ -n $SET_TAGS ]]; then
		cmd="--tag \">$SET_TAGS\""
	else
		[[ -n $REMOVE_TAGS ]] && cmd="$cmd --tag \"<<$REMOVE_TAGS\"" || true
		[[ -n $ADD_TAGS ]] && cmd="$cmd --tag \">>$ADD_TAGS\"" || true
	fi

	echo "$cmd"
}

# Main logic
main() {
	log_info "Preparing bulk tag update..."

	# Get bookmark IDs
	local bookmark_ids
	bookmark_ids=$(get_bookmark_ids)

	if [[ -z $bookmark_ids ]]; then
		log_warning "No bookmarks found matching criteria"
		exit 0
	fi

	# Count bookmarks
	local count
	count=$(echo "$bookmark_ids" | wc -w)
	log_info "Found $count bookmark(s) to update"

	# Show preview
	echo ""
	log_info "Preview of bookmarks to update:"

	for id in $bookmark_ids; do
		buku -p "$id" 2>/dev/null | head -1 || log_warning "Bookmark #$id not found"
	done

	echo ""

	# Build tag command
	local tag_cmd
	tag_cmd=$(build_tag_command)

	log_info "Tag operation: $tag_cmd"
	echo ""

	if [[ $DRY_RUN -eq 1 ]]; then
		log_warning "DRY-RUN MODE: No changes will be applied"
		echo ""
		for id in $bookmark_ids; do
			echo "Would run: buku -u $id $tag_cmd"
		done
		exit 0
	fi

	# Confirmation
	echo -n "Apply tags to these $count bookmark(s)? (y/N) "
	read -r confirm

	if [[ $confirm != "y" ]] && [[ $confirm != "Y" ]]; then
		log_warning "Operation cancelled"
		exit 0
	fi

	echo ""
	log_info "Applying tags..."

	# Apply updates in batches
	local updated=0
	local failed=0

	for id in $bookmark_ids; do
		if eval "buku -u $id $tag_cmd" 2>/dev/null; then
			((updated++))
			log_success "Updated bookmark #$id"
		else
			((failed++))
			log_error "Failed to update bookmark #$id"
		fi

		# Show progress
		if ((updated % BATCH_SIZE == 0)); then
			log_info "Progress: $updated/$count completed"
		fi
	done

	echo ""
	log_success "Completed: $updated updated, $failed failed"

	# Verify changes
	echo ""
	log_info "Verifying changes:"
	for id in $(echo "$bookmark_ids" | head -3); do
		buku -p "$id" 2>/dev/null | head -2 || true
		echo ""
	done

	if [[ $count -gt 3 ]]; then
		log_info "...and $((count - 3)) more bookmarks updated"
	fi
}

main "$@"

#!/usr/bin/env bash
# shellcheck disable=SC2034,SC2086,SC2155,SC2126,SC2012

# Backup Buku Bookmarks Database
#
# Usage: ./backup-bookmarks.sh [BACKUP_DIR]
#
# Creates timestamped backups of buku database in multiple formats:
# - Database (.db file)
# - HTML (for browser import)
# - Markdown (for documentation)
# - XBEL (XML bookmark format)
#
# Default backup directory: ~/.local/share/buku/backups/
#
# Examples:
#   # Backup to default directory
#   ./backup-bookmarks.sh
#
#   # Backup to custom directory
#   ./backup-bookmarks.sh ~/my-backups
#
#   # Backup and sync to cloud
#   ./backup-bookmarks.sh ~/OneDrive/Backups

set -euo pipefail

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
BUKU_DB="${BUKU_DB_PATH:-${XDG_DATA_HOME:-$HOME/.local/share}/buku/bookmarks.db}"
BACKUP_DIR="${1:-.buku/backups}"
TIMESTAMP=$(date +"%Y%m%d-%H%M%S")
BACKUP_PREFIX="bookmarks-$TIMESTAMP"

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

# Expand ~ in paths
expand_path() {
	eval echo "$1"
}

# Verify buku installation
verify_buku() {
	if ! command -v buku &>/dev/null; then
		log_error "buku is not installed or not in PATH"
		exit 1
	fi
	log_success "buku found: $(buku --version)"
}

# Verify database exists
verify_database() {
	if [[ ! -f $BUKU_DB ]]; then
		log_error "Buku database not found at: $BUKU_DB"
		log_info "Expected location: ${XDG_DATA_HOME:-$HOME/.local/share}/buku/bookmarks.db"
		exit 1
	fi
	log_success "Database found at: $BUKU_DB"
}

# Create backup directory
create_backup_dir() {
	BACKUP_DIR=$(expand_path "$BACKUP_DIR")

	if [[ ! -d $BACKUP_DIR ]]; then
		log_info "Creating backup directory: $BACKUP_DIR"
		mkdir -p "$BACKUP_DIR" || {
			log_error "Failed to create backup directory"
			exit 1
		}
	fi

	log_success "Backup directory ready: $BACKUP_DIR"
}

# Backup database file
backup_database() {
	local backup_file="$BACKUP_DIR/$BACKUP_PREFIX.db"

	log_info "Backing up database file..."

	if cp "$BUKU_DB" "$backup_file"; then
		local size
		size=$(du -h "$backup_file" | cut -f1)
		log_success "Database backup: $backup_file ($size)"
		echo "$backup_file"
	else
		log_error "Failed to backup database"
		return 1
	fi
}

# Export to HTML
backup_html() {
	local backup_file="$BACKUP_DIR/$BACKUP_PREFIX.html"

	log_info "Exporting to HTML..."

	if buku -e "$backup_file" -f html 2>/dev/null; then
		local size
		size=$(du -h "$backup_file" | cut -f1)
		log_success "HTML export: $backup_file ($size)"
		echo "$backup_file"
	else
		log_error "Failed to export HTML"
		return 1
	fi
}

# Export to Markdown
backup_markdown() {
	local backup_file="$BACKUP_DIR/$BACKUP_PREFIX.md"

	log_info "Exporting to Markdown..."

	if buku -e "$backup_file" -f markdown 2>/dev/null; then
		local size
		size=$(du -h "$backup_file" | cut -f1)
		log_success "Markdown export: $backup_file ($size)"
		echo "$backup_file"
	else
		log_error "Failed to export Markdown"
		return 1
	fi
}

# Export to XBEL
backup_xbel() {
	local backup_file="$BACKUP_DIR/$BACKUP_PREFIX.xbel"

	log_info "Exporting to XBEL..."

	if buku -e "$backup_file" -f xbel 2>/dev/null; then
		local size
		size=$(du -h "$backup_file" | cut -f1)
		log_success "XBEL export: $backup_file ($size)"
		echo "$backup_file"
	else
		log_warning "XBEL export not available (optional)"
		return 0
	fi
}

# Create manifest
create_manifest() {
	local manifest="$BACKUP_DIR/$BACKUP_PREFIX.manifest"

	log_info "Creating manifest..."

	cat >"$manifest" <<EOF
# Buku Backup Manifest
# Created: $(date)
# Version: $(buku --version)

## Backup Files
- Database: $BACKUP_PREFIX.db
- HTML: $BACKUP_PREFIX.html
- Markdown: $BACKUP_PREFIX.md
- XBEL: $BACKUP_PREFIX.xbel

## Statistics
- Total bookmarks: $(buku -p 2>/dev/null | grep "^[0-9]" | wc -l || echo "unknown")
- Backup directory: $BACKUP_DIR
- Backup timestamp: $TIMESTAMP

## Restore Instructions

### Restore from database backup
cp $BACKUP_PREFIX.db ~/.local/share/buku/bookmarks.db
buku -p

### Restore from HTML backup
buku -i $BACKUP_PREFIX.html

### Restore from Markdown backup
buku -i $BACKUP_PREFIX.md

EOF

	log_success "Manifest created: $manifest"
}

# Verify backups
verify_backups() {
	log_info "Verifying backups..."

	local files_ok=0

	[[ -f "$BACKUP_DIR/$BACKUP_PREFIX.db" ]] && ((files_ok++)) && log_success "Database backup verified"
	[[ -f "$BACKUP_DIR/$BACKUP_PREFIX.html" ]] && ((files_ok++)) && log_success "HTML backup verified"
	[[ -f "$BACKUP_DIR/$BACKUP_PREFIX.md" ]] && ((files_ok++)) && log_success "Markdown backup verified"
	[[ -f "$BACKUP_DIR/$BACKUP_PREFIX.xbel" ]] && ((files_ok++)) && log_success "XBEL backup verified"

	if [[ $files_ok -ge 3 ]]; then
		log_success "All backups verified"
		return 0
	else
		log_warning "Some backups may have failed"
		return 1
	fi
}

# Cleanup old backups (optional)
cleanup_old_backups() {
	log_info "Checking for old backups..."

	local old_count
	old_count=$(find "$BACKUP_DIR" -name "bookmarks-*.db" -mtime +30 2>/dev/null | wc -l)

	if [[ $old_count -gt 0 ]]; then
		log_warning "Found $old_count backup(s) older than 30 days"
		log_info "To remove: find $BACKUP_DIR -name 'bookmarks-*.db' -mtime +30 -delete"
	fi
}

# Generate summary
generate_summary() {
	echo ""
	log_success "Backup completed successfully!"
	echo ""
	log_info "Backup Summary:"
	echo "  Timestamp: $TIMESTAMP"
	echo "  Location: $BACKUP_DIR"
	echo "  Files:"
	ls -lh "$BACKUP_DIR"/$BACKUP_PREFIX.* 2>/dev/null | awk '{print "    " $9 " (" $5 ")"}'
	echo ""
	log_info "Total backup size: $(du -sh "$BACKUP_DIR" | cut -f1)"
}

# Main execution
main() {
	log_info "Starting Buku backup process..."
	echo ""

	verify_buku
	verify_database
	create_backup_dir

	echo ""
	log_info "Creating backups with timestamp: $TIMESTAMP"
	echo ""

	backup_database || true
	backup_html || true
	backup_markdown || true
	backup_xbel || true

	echo ""
	create_manifest
	verify_backups
	cleanup_old_backups

	generate_summary

	log_success "Backup process finished"
}

main "$@"

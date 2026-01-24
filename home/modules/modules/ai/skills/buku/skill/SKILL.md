---
name: buku
description: |
  Bookmark management CLI for searching, organizing, and syncing bookmarks
  with tagging, import/export, and browser integration. Use when helping end
  users manage bookmarks via CLI: (1) Adding and searching bookmarks,
  (2) Organizing with tags, (3) Importing from browsers or files,
  (4) Exporting and backing up, (5) Bulk operations and migrations.
license: GPLv3
compatibility: opencode
metadata:
  audience: end-users
  workflow: bookmark-management
---

# Buku Bookmark Manager Skill

**Buku** is a powerful command-line bookmark manager that lets you search,
organize, import, and export bookmarks with full-text search, tagging, and
browser integration.

## What You Can Do With Buku

- **Search & Organize**: Quick bookmark addition with full-text search and
  regex, flexible tag operators for organization
- **Import & Export**: Auto-import from Firefox, Chrome, Edge, Brave, Vivaldi,
  Chromium; export to HTML, XBEL, Markdown, Orgfile, RSS, or new database
- **Bulk Operations**: Update bookmarks, rename tags across collections,
  filter and manage entire bookmark sets
- **Browser Integration & Backup**: Launch bookmarks from CLI, automated
  database backups with versioning

## When to Use This Skill

Load this skill when:

- User wants to add, search, or manage bookmarks from the command line
- User needs to organize bookmarks with tags
- User wants to import bookmarks from a web browser
- User needs to export bookmarks for backup or migration
- User encounters errors or needs database recovery assistance
- User is troubleshooting buku-related issues

## Recovery & Safety

Buku is designed for safe bookmark management with built-in protections:

- **Database Locking**: If you encounter "Database is locked" errors, close
  your browser and retry. See
  `references/troubleshooting.md#error-database-is-locked` for detailed
  recovery steps.

- **Import Safety**: Duplicate detection prevents accidental overwrites on
  re-import. New bookmarks are always added safely. See
  `references/troubleshooting.md#error-bookmark-already-exists` for import
  strategies.

- **Bulk Operations**: Always backup before performing large tag updates or
  deletions. Use `scripts/backup-bookmarks.sh` for automated backups.
  See `references/troubleshooting.md#prevention-tips` for best practices.

## Quick Start

1. **Set your editor** (for bookmark editing):

   ```bash
   export EDITOR=vim  # or nano, gedit, macvim, etc.
   ```

2. **Create your first bookmark**:

   ```bash
   buku -a https://example.com "Example Site" "useful" "reference"
   ```

3. **Search your bookmarks**:

   ```bash
   buku -s example
   ```

4. **View all bookmarks**:

   ```bash
   buku -p
   ```

5. **Troubleshoot if EDITOR won't open**:

   If running `buku -w BOOKMARK_ID` fails with "EDITOR not set", quickly fix:

   ```bash
   export EDITOR=vim  # or nano, gedit, code --wait
   buku -w 1          # Now should open in editor
   ```

   For detailed editor setup and other troubleshooting:
   See `references/troubleshooting.md`

## Documentation Guide

Choose the reference that matches your need:

### Getting Started

`references/getting-started.md` - First time with buku? Start here for
installation verification, EDITOR setup, and your first bookmark.

### Daily Workflows

`references/daily-workflows.md` - Common daily tasks: adding bookmarks,
searching, updating, deleting, opening in browser, copying URLs.

### Organize with Tags

`references/organize-bookmarks.md` - Tagging strategies, tag operators,
tag search, renaming tags, and organization best practices.

### Import & Export

`references/migrate-bookmarks.md` - Importing from browsers, manual imports,
exporting to different formats, backups, and merging bookmarks.

### Troubleshooting

`references/troubleshooting.md` - Common errors, EDITOR issues, database
locking, and recovery strategies.

## Production Scripts

Pre-built scripts for common workflows:

- `scripts/bulk-update-tags.sh` - Update tags on multiple bookmarks
- `scripts/backup-bookmarks.sh` - Automated backups with multiple formats
- `scripts/browser-import-workflow.sh` - Safe browser import with checks

## Learn More

- Official Docs: <https://buku.readthedocs.io/>
- GitHub: <https://github.com/jarun/buku>
- Database Location: `~/.local/share/buku/bookmarks.db` or
  `$XDG_DATA_HOME/buku/bookmarks.db`

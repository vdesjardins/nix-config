<!-- markdownlint-disable MD013 -->
# Importing and Exporting Bookmarks

## Auto-Import from Web Browsers

Buku can automatically import bookmarks from your default web browser's export file.

### Supported Browsers

- Firefox
- Chrome
- Chromium
- Edge
- Brave
- Vivaldi

### Step 1: Export from Your Browser

#### Firefox

1. Open Firefox
2. Menu → Bookmarks → Manage Bookmarks (or Ctrl+Shift+B)
3. Menu (three dots) → Export Bookmarks
4. Save as HTML file (e.g., `firefox-bookmarks.html`)

#### Chrome/Chromium/Edge/Brave

1. Open the browser
2. Menu (three dots) → Bookmarks → Bookmark manager
3. Menu (three dots) → Export bookmarks
4. Save as HTML file (e.g., `chrome-bookmarks.html`)

### Step 2: Import into Buku

```bash
buku -i ~/Downloads/firefox-bookmarks.html
```

Or use the auto-import feature:

```bash
buku --ai
```

The `--ai` flag auto-detects your browser and imports automatically (requires browser not to be running).

### Step 3: Verify Import

```bash
buku -p
```

View all bookmarks to confirm the import succeeded.

### Step 4: Tag Imported Bookmarks (Optional)

After import, you may want to tag all imported bookmarks:

```bash
# Find the latest bookmarks (highest IDs)
# Then tag them
buku -u 1-500 --tag ">>imported"
```

Or use the provided script:

```bash
./scripts/browser-import-workflow.sh
```

## Manual Import from Files

### From HTML Files

```bash
buku -i bookmarks.html
```

Works with exported bookmarks from any browser.

### From XBEL Files

XBEL (XML Bookmark Exchange Language) format:

```bash
buku -i bookmarks.xbel
```

### From Markdown Files

Import from a Markdown-formatted bookmark list:

```bash
buku -i bookmarks.md
```

Expected Markdown format:

```markdown
# Bookmarks

## Development
- [GitHub](https://github.com)
- [Stack Overflow](https://stackoverflow.com)

## Reference
- [Wikipedia](https://wikipedia.org)
```

### From Orgfile Files

Emacs Org-mode format:

```bash
buku -i bookmarks.org
```

### From RSS Feeds

Import from an RSS feed (extracts links):

```bash
buku -i https://example.com/feed.rss
```

Or from a local RSS file:

```bash
buku -i bookmarks.rss
```

### From Existing Buku Database

Merge bookmarks from another buku database:

```bash
buku -i ~/.local/share/buku/bookmarks-old.db
```

## Exporting Bookmarks

### Export All to HTML

Create a shareable or backup HTML file:

```bash
buku -e bookmarks-all.html -f html
```

This creates a standard HTML bookmark file that most browsers can import.

### Export to XBEL Format

For advanced bookmark management:

```bash
buku -e bookmarks.xbel -f xbel
```

### Export to Markdown

Create a Markdown list for documentation or sharing:

```bash
buku -e bookmarks.md -f markdown
```

Output example:

```markdown
# Bookmarks

1. [GitHub: Where the world builds software](https://github.com)
   Tags: dev, code

2. [Python Software Foundation](https://python.org)
   Tags: lang, python
```

### Export to Orgfile Format

For Emacs users:

```bash
buku -e bookmarks.org -f orgfile
```

### Export to RSS Feed

Create an RSS feed of your bookmarks:

```bash
buku -e bookmarks.rss -f rss
```

### Export as New Database

Create a separate buku database file:

```bash
buku -e backup-db.db -f db
```

This can be imported into another buku installation.

## Exporting with Filters

### Export Only Specific Tags

Export only bookmarks with a particular tag:

```bash
buku -t python -e python-bookmarks.html -f html
```

Or multiple tags (ANY match):

```bash
buku -t dev code -e dev-bookmarks.html -f html
```

### Export Search Results

Export only bookmarks matching a search:

```bash
buku -s github -e github-bookmarks.html -f html
```

### Export Specific Bookmarks

Export bookmarks #1, #3, #5:

```bash
buku -p 1 3 5 | buku -e selected.html -f html
```

Or export a range:

```bash
buku -p 1-10 | buku -e bookmarks-1-10.html -f html
```

## Database Backup and Restore

### Backup Strategy

Regular backups protect against data loss:

```bash
# Simple backup
cp ~/.local/share/buku/bookmarks.db ~/backups/bookmarks-$(date +%Y%m%d).db

# Or use the provided script
./scripts/backup-bookmarks.sh
```

The provided script creates timestamped backups in multiple formats (HTML, Markdown, and database).

### Restore from Backup

#### Restore Database File

If you have a backup database file:

```bash
cp ~/backups/bookmarks-20240115.db ~/.local/share/buku/bookmarks.db
```

Then verify:

```bash
buku -p
```

#### Restore from HTML Backup

If you only have an HTML export:

```bash
buku -i backups/bookmarks-20240115.html
```

This imports the bookmarks from the HTML file.

### Incremental Backup Strategy

1. Daily database backup:

   ```bash
   cp ~/.local/share/buku/bookmarks.db ~/backups/bookmarks-$(date +%Y%m%d).db
   ```

2. Monthly HTML export:

   ```bash
   buku -e ~/backups/bookmarks-$(date +%Y%m).html -f html
   ```

3. Store backups in multiple locations (cloud, external drive).

## Merging Bookmarks from Multiple Sources

### Scenario: Merging Two Buku Instances

You have bookmarks on two different machines and want to merge them.

#### Step 1: Export from Machine 1

On machine 1:

```bash
buku -e ~/Downloads/bookmarks-machine1.html -f html
```

#### Step 2: Transfer File

Transfer the HTML file to machine 2.

#### Step 3: Import on Machine 2

On machine 2:

```bash
buku -i ~/Downloads/bookmarks-machine1.html
```

#### Step 4: Handle Duplicates

Buku warns about duplicates. You can:

- Skip duplicates (default)
- Merge with `-oa` (overwrite all)
- Let buku detect and handle automatically

### Scenario: Consolidating Multiple Browser Exports

You want to merge Chrome, Firefox, and Safari bookmarks:

```bash
# Export from each browser (following browser-specific steps above)

# Import all into buku
buku -i ~/Downloads/chrome-bookmarks.html
buku -i ~/Downloads/firefox-bookmarks.html
buku -i ~/Downloads/safari-bookmarks.html

# Tag them by source
buku -t imported -u 1-500 --tag ">>source/chrome"
```

## Advanced: Syncing Across Machines

### Option 1: Cloud Sync with Git

Store your buku database in a Git repository (private):

```bash
cd ~/backups
git init buku-sync
cd buku-sync
cp ~/.local/share/buku/bookmarks.db .
git add bookmarks.db
git commit -m "Initial backup"
git remote add origin <your-git-repo>
git push -u origin main
```

On another machine:

```bash
git clone <your-git-repo>
cp buku-sync/bookmarks.db ~/.local/share/buku/bookmarks.db
```

### Option 2: Symbolic Link to Cloud Storage

Link your buku database to cloud storage:

```bash
# Backup original
cp ~/.local/share/buku/bookmarks.db ~/backups/

# Create symlink to cloud storage
ln -s ~/OneDrive/Documents/bookmarks.db ~/.local/share/buku/bookmarks.db
```

**Note**: Cloud storage must sync before accessing from another machine.

## Common Export Scenarios

| Scenario | Command |
|----------|---------|
| Backup all bookmarks (HTML) | `buku -e backup.html -f html` |
| Share with others (HTML) | `buku -t ">>public" -e public.html -f html` |
| Markdown for documentation | `buku -e README.md -f markdown` |
| Import from browser | `buku -i ~/Downloads/*-bookmarks.html` |
| Restore from backup | `buku -i ~/backups/bookmarks-old.html` |
| Create new DB from export | `buku -i bookmarks.html && buku -e new.db -f db` |

## Troubleshooting Import/Export

### Import Shows "Already Exists" Errors

This is normal when re-importing. Buku detects duplicates and skips them.

To skip duplicates silently:

```bash
buku -i bookmarks.html 2>/dev/null
```

### Export File is Large

If your export file is very large, consider exporting by tags:

```bash
# Export specific tags to separate files
buku -t work -e work-bookmarks.html -f html
buku -t personal -e personal-bookmarks.html -f html
```

### Import Takes Too Long

For very large bookmark files, import may be slow on first run. This is normal as buku:

- Fetches titles from URLs
- Processes metadata
- Detects duplicates

Be patient or use `-ai` (auto-import) which is optimized.

## Best Practices

1. **Regular backups**: Export monthly as HTML for safety
2. **Multiple formats**: Keep both database and HTML backups
3. **Cloud backup**: Use cloud storage for important backups
4. **Test imports**: Always verify after importing with `buku -p`
5. **Tag imports**: Add source tags when importing from external sources
6. **Version control**: Consider storing backups in Git for history

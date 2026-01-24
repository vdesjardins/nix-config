<!-- markdownlint-disable MD013 -->
# Troubleshooting Buku

## Common Errors and Solutions

### Error: "Bookmark Already Exists"

**Problem**: When importing bookmarks, you see "Bookmark already exists" warnings.

**Cause**: Buku detected duplicate URLs. This is normal when re-importing bookmarks.

**Solution**:

Option 1: Ignore the warnings (safe):

```bash
buku -i bookmarks.html
# Press 'y' to skip duplicates
```

Option 2: Suppress warnings:

```bash
buku -i bookmarks.html 2>/dev/null
```

Option 3: Import with overwrite flag:

```bash
buku -i bookmarks.html -oa
# This overwrites existing bookmarks with new metadata
```

---

### Error: "Immutable Bookmark (L)"

**Problem**: When trying to edit a bookmark, you see "(L)" marker indicating it's immutable (locked).

**Cause**: Some bookmarks are marked as immutable and cannot be edited through buku.

**Solution**:

**Delete and re-add**:

```bash
# Get the URL first
buku -p BOOKMARK_ID | grep "^http"

# Delete the immutable bookmark
buku -d BOOKMARK_ID

# Re-add with new metadata
buku -a <URL> "<NEW TITLE>" "tag1,tag2"
```

---

### Error: "Database Is Locked"

**Problem**: You get "Database is locked" error when trying to modify bookmarks.

**Cause**: Another process has the database open (usually your web browser running auto-import).

**Solution**:

**Option 1**: Close your browser:

```bash
# Kill browser process
killall firefox
# or
killall chromium
```

Then retry your buku command.

**Option 2**: Wait and retry:

```bash
sleep 5
buku -u 3 --title "New Title"
```

**Option 3**: Use a different buku database temporarily:

```bash
BUKU_DB_PATH=~/.local/share/buku/bookmarks-temp.db buku -a https://example.com
```

---

### Error: "EDITOR Not Set" or Editor Won't Open

**Problem**: When running `buku -w BOOKMARK_ID`, your editor doesn't open, or you get an error.

**Cause**: `EDITOR` environment variable is not set or points to an invalid editor.

**Solution**:

**Step 1**: Check current EDITOR setting:

```bash
echo $EDITOR
```

If empty, proceed to Step 2.

**Step 2**: Set EDITOR for your preferred editor:

**Vim**:

```bash
export EDITOR=vim
```

**Nano**:

```bash
export EDITOR=nano
```

**Gedit** (Ubuntu/GNOME):

```bash
export EDITOR=gedit
```

**VS Code**:

```bash
export EDITOR="code --wait"
```

**macvim** (macOS):

```bash
export EDITOR=macvim
```

**Step 3**: Make it permanent by adding to your shell config file:

Edit `~/.bashrc` or `~/.zshrc`:

```bash
export EDITOR=vim  # Replace with your editor
```

Then reload:

```bash
source ~/.bashrc  # or source ~/.zshrc
```

**Step 4**: Verify:

```bash
echo $EDITOR
buku -w 3  # Should open editor now
```

---

### Error: "Title Could Not Be Fetched"

**Problem**: When adding a bookmark without specifying a title, buku fails to fetch the title from the URL.

**Cause**:

- Website is offline or unreachable
- Website blocks automated requests
- Network connectivity issue

**Solution**:

**Option 1**: Provide title manually:

```bash
buku -a https://example.com "My Custom Title" "tag1,tag2"
```

**Option 2**: Add without title (buku uses URL as fallback):

```bash
buku -a https://example.com
# Bookmark created with title = URL
```

**Option 3**: Update title later:

```bash
buku -a https://example.com
# Then when website is accessible:
buku --refresh 3  # Update bookmark #3
```

---

### Error: "Index Moved" After Deletion

**Problem**: After deleting bookmarks, the remaining bookmark IDs seem to have changed or moved.

**Cause**: This is not an error. When you delete a bookmark, higher-numbered bookmarks shift down to fill the gap. This is normal behavior.

**Example**:

```text
Before deletion:
1. GitHub
2. Wikipedia
3. Stack Overflow

After deleting #2:
1. GitHub
2. Stack Overflow  # Was #3, now #2
```

**No action needed**: The IDs are automatically renumbered. This is expected behavior.

---

### Issue: Very Slow Search

**Problem**: Searching bookmarks takes a long time.

**Cause**:

- Large database with thousands of bookmarks
- Full-text search on all records
- Regex search on complex patterns

**Solutions**:

**Option 1**: Use tag search (fastest):

```bash
buku -t python  # Much faster than -s python
```

**Option 2**: Use ALL keywords search (narrower):

```bash
buku -S python documentation  # Faster than -s python
```

**Option 3**: Combine tag and search:

```bash
buku -t work -s python  # Find "python" only in "work" bookmarks
```

**Option 4**: Index by substring instead of regex:

```bash
buku --subs "github.com"  # Faster than --regex
```

---

### Issue: Bookmark Not Updating

**Problem**: After running `buku -u BOOKMARK_ID`, the bookmark hasn't changed.

**Cause**: Multiple possible reasons:

- Wrong bookmark ID
- Missing `--` separator for complex commands
- Tags not using operators (>>, >, <<)

**Solution**:

**Option 1**: Verify bookmark exists:

```bash
buku -p BOOKMARK_ID
```

**Option 2**: Use full syntax with operators:

```bash
# WRONG - will replace all tags:
buku -u 3 --tag "newtag"

# CORRECT - will append:
buku -u 3 --tag ">>newTag"

# CORRECT - will replace:
buku -u 3 --tag ">newTag"
```

**Option 3**: Update with editor:

```bash
buku -w 3  # Opens editor for full control
```

---

### Issue: Can't Find Database After Migration

**Problem**: After moving or reinstalling, `buku -p` shows no bookmarks.

**Cause**: Buku is looking in default location but database moved or not migrated.

**Default Database Location**:

```bash
~/.local/share/buku/bookmarks.db
```

Or with `$XDG_DATA_HOME`:

```bash
$XDG_DATA_HOME/buku/bookmarks.db
```

**Solution**:

**Option 1**: Check current location:

```bash
ls -la ~/.local/share/buku/bookmarks.db
```

**Option 2**: If file exists, verify buku sees it:

```bash
buku -p
```

**Option 3**: Restore from backup:

```bash
cp ~/backups/bookmarks-backup.db ~/.local/share/buku/bookmarks.db
```

**Option 4**: Import from HTML backup:

```bash
buku -i ~/backups/bookmarks.html
```

---

### Issue: Bookmarks Not Persisting After Import

**Problem**: Import seems successful, but bookmarks disappear after closing terminal.

**Cause**: Import might have failed silently, or database wasn't properly saved.

**Solution**:

**Option 1**: Verify import worked:

```bash
buku -p  # Should show imported bookmarks
```

**Option 2**: Check database size:

```bash
ls -lh ~/.local/share/buku/bookmarks.db
```

**Option 3**: Force sync to disk:

```bash
buku -e test-backup.html -f html  # This forces a database read/write
```

**Option 4**: Re-import with verbose output:

```bash
buku -i bookmarks.html -v
```

---

## Performance Optimization

### Database Cleanup

Over time, metadata might accumulate. Optimize:

```bash
# Export all bookmarks
buku -e bookmarks-clean.html -f html

# Backup old database
mv ~/.local/share/buku/bookmarks.db ~/.local/share/buku/bookmarks-old.db

# Create fresh database (buku creates automatically)
buku -p

# Import clean version
buku -i bookmarks-clean.html
```

### Disable Title Fetching on Import

If imports are slow, disable fetching titles from URLs:

```bash
# Check if option exists in your buku version
buku -i bookmarks.html --no-fetch
```

---

## Getting Help

### Check Buku Version and Help

```bash
buku --version
buku --help
buku -h
```

### View Detailed Command Help

```bash
man buku
```

### Check Online Documentation

- Official Docs: <https://buku.readthedocs.io/>
- GitHub Issues: <https://github.com/jarun/buku/issues>
- Examples: <https://github.com/jarun/buku#examples>

### Enable Debug Logging

Some buku versions support debug output:

```bash
buku -d  # May enable debug mode
```

Check your buku version's help for exact syntax.

---

## Prevention Tips

1. **Regular backups**: Run backup script monthly

   ```bash
   ./scripts/backup-bookmarks.sh
   ```

2. **Tag strategy**: Use consistent tagging to avoid confusion

   ```bash
   buku --stag  # Review all tags regularly
   ```

3. **Version control**: Store backups in Git for history

   ```bash
   git init ~/buku-backups && cd ~/buku-backups
   cp ~/.local/share/buku/bookmarks.db . && git add bookmarks.db && git commit -m "Backup"
   ```

4. **Test imports**: Always verify with `buku -p` after importing

   ```bash
   buku -i new-bookmarks.html
   buku -p | tail -20  # Check last imported bookmarks
   ```

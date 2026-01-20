<!-- markdownlint-disable MD013 -->
# Organizing Bookmarks with Tags

## Tag Fundamentals

### What Are Tags?

Tags are comma-separated labels that help organize and categorize bookmarks. Each bookmark can have multiple tags.

### Tag Rules

- **Case-sensitive**: `Python` and `python` are different tags
- **Comma-separated**: `dev,python,tutorial` creates three tags
- **Spaces allowed**: `machine learning` is valid
- **Special characters**: Avoid special characters; use hyphens or underscores instead
- **No limit**: Add as many tags as needed

### Example Tags

```bash
# Add a bookmark with multiple tags
buku -a https://python.org "Python" "lang,dev,official"
```

This creates three tags: `lang`, `dev`, `official`.

## Tag Operators

Buku uses three tag operators for advanced tag management:

### 1. Append Tag (`>>`)

Add tags to existing bookmarks without removing old tags:

```bash
buku -u 3 --tag ">>learning"
```

**Before**: `python,dev`  
**After**: `python,dev,learning`

The `>>` preserves existing tags and adds new ones.

### 2. Set Tag (`>`)

Replace all tags (remove old, set new):

```bash
buku -u 3 --tag ">python,tutorial"
```

**Before**: `python,dev,learning`  
**After**: `python,tutorial`

Use `>` when you want to completely replace the tag list.

### 3. Remove Tag (`<<`)

Remove specific tags:

```bash
buku -u 3 --tag "<<dev"
```

**Before**: `python,dev,learning`  
**After**: `python,learning`

The `<<` operator removes only specified tags.

### Operator Examples

```bash
# Append "important" to bookmark #5
buku -u 5 --tag ">>important"

# Set bookmark #7 tags to only "work,urgent"
buku -u 7 --tag ">work,urgent"

# Remove "old" tag from bookmark #2
buku -u 2 --tag "<<old"

# Multiple operations on one bookmark
buku -u 10 --tag ">>archive" --tag "<<temporary"
```

## Adding Tags to New Bookmarks

### Single Tag

```bash
buku -a https://github.com "GitHub" "dev"
```

### Multiple Tags (Comma-Separated)

```bash
buku -a https://github.com "GitHub" "dev,code,repository"
```

### Multiple Tags (Space-Separated)

```bash
buku -a https://github.com "GitHub" dev code repository
```

Both approaches work. Use commas for clarity.

## Managing Tags on Existing Bookmarks

### Add New Tag (Keep Existing)

```bash
buku -u 3 --tag ">>important"
```

### Replace All Tags

```bash
buku -u 3 --tag ">backup,archive"
```

### Remove Specific Tag

```bash
buku -u 3 --tag "<<old"
```

### Remove All Tags

```bash
buku -u 3 --tag ">"
```

Setting tags to `>` with no tags removes all.

## Tag Search Patterns

### 1. Search by Single Tag

Find all bookmarks with a specific tag:

```bash
buku -t dev
```

Shows all bookmarks tagged "dev".

### 2. Search by Multiple Tags (ANY Match)

Find bookmarks with at least one of these tags:

```bash
buku -t dev python
```

Shows bookmarks with "dev" OR "python".

### 3. Search by Multiple Tags (ALL Match)

Find bookmarks with all specified tags (use `+`):

```bash
buku -t "dev+learning"
```

Shows only bookmarks that have BOTH "dev" AND "learning".

### 4. Exclude Tags

Find bookmarks without a specific tag:

```bash
buku -t "-old"
```

Shows all bookmarks except those tagged "old".

### 5. Complex Tag Searches

Combine patterns:

```bash
buku -t "dev+python" "-tutorial"
```

Finds bookmarks with BOTH "dev" AND "python", but NOT "tutorial".

## Renaming Tags (Bulk Update)

Rename a tag across all bookmarks:

### Using Script (Recommended)

Use the provided `scripts/bulk-update-tags.sh`:

```bash
./scripts/bulk-update-tags.sh "old-tag" "new-tag"
```

### Manual Approach

1. Find all bookmarks with the old tag:

   ```bash
   buku -t old-tag
   ```

2. For each bookmark, remove old tag and add new one:

   ```bash
   buku -u BOOKMARK_ID --tag "<<old-tag" --tag ">>new-tag"
   ```

Or use a shell loop:

```bash
for id in $(buku -t old-tag -p | cut -d. -f1); do
  buku -u $id --tag "<<old-tag" --tag ">>new-tag"
done
```

## Listing All Tags

See all unique tags in your database:

```bash
buku --stag
```

Output:

```text
dev
python
learning
reference
tutorial
```

Count how many bookmarks per tag:

```bash
buku --stag -c
```

## Tag Organization Strategies

### Strategy 1: Hierarchical Tags (Recommended)

Use a hierarchy-like structure with category/subcategory:

```bash
lang/python
lang/javascript
lang/rust
tool/editor
tool/terminal
ref/documentation
ref/tutorial
```

Usage:

```bash
buku -a https://python.org "Python" "lang/python,official"
buku -t "lang/python"  # Find all Python resources
```

### Strategy 2: Flat Tags

Keep tags simple and flat:

```bash
python, javascript, rust
editor, terminal, browser
docs, tutorial, guide
```

Usage:

```bash
buku -a https://python.org "Python" "python,official"
buku -t "python"
```

### Strategy 3: Hybrid Approach

Combine category and property tags:

```bash
# Category + Property
dev/python
status/archived
type/tutorial
importance/critical
```

Usage:

```bash
buku -u 5 --tag ">>importance/critical" ">>status/active"
```

### Strategy 4: Status Tags

Track bookmark lifecycle:

```bash
status/active
status/archived
status/reviewing
status/deprecated
```

Usage:

```bash
# Archive a bookmark
buku -u 10 --tag "<<status/active" --tag ">>status/archived"

# Find all archived
buku -t "status/archived"
```

## Tag Maintenance

### Find Orphaned Tags (No Bookmarks)

```bash
buku --stag | while read tag; do
  count=$(buku -t "$tag" -p 2>/dev/null | wc -l)
  [ $count -eq 0 ] && echo "Orphaned: $tag"
done
```

### Find Single-Use Tags

```bash
buku --stag -c | awk '$NF == 1 { print $1 }'
```

Shows tags used on only one bookmark. Consider consolidating.

### Merge Similar Tags

If you have both `python` and `py`, merge them:

```bash
for id in $(buku -t py -p | cut -d. -f1); do
  buku -u $id --tag "<<py" --tag ">>python"
done
```

## Tips and Best Practices

1. **Be consistent**: Decide on naming (lowercase, hyphenated, hierarchical) and stick to it
2. **Avoid over-tagging**: Too many tags per bookmark defeats organization
3. **Keep tags meaningful**: Avoid tags like "stuff" or "misc"
4. **Review periodically**: Use `buku --stag` monthly to maintain tag hygiene
5. **Archive old tags**: Mark deprecated tags with a "deprecated/" prefix before removing
6. **Document your system**: Write down your tagging strategy so you remember it later

## Common Patterns

### Work vs Personal

```bash
area/work, area/personal
```

### Priority Levels

```bash
priority/high, priority/medium, priority/low
```

### Content Type

```bash
type/article, type/video, type/tool, type/documentation
```

### Lifecycle

```bash
stage/todo, stage/reading, stage/done
```

Combine these: `area/work+type/article+stage/reading`

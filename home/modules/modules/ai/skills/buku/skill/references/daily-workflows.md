<!-- markdownlint-disable MD013 -->
# Daily Workflows with Buku

## Adding Bookmarks

### 1. Simple Add (URL Only)

Buku auto-fetches the title from the webpage:

```bash
buku -a https://github.com
```

Result: Creates bookmark with fetched title.

### 2. Add with Title and Tags

```bash
buku -a https://github.com "GitHub" "dev,code,repository"
```

### 3. Add from Editor (With Comments)

Use `-w` to open your editor for full editing:

```bash
buku -a https://github.com -w
```

Editor opens showing:

```text
https://github.com
Tags:
Title: [auto-fetched]

[Add comments/notes here - optional]
```

### 4. Add Multiple Bookmarks from File

Create a file `bookmarks.txt` with URLs (one per line):

```text
https://github.com
https://stackoverflow.com
https://reddit.com
```

Then import:

```bash
buku -i bookmarks.txt
```

### 5. Add with Pipe

Get URLs from other commands:

```bash
echo "https://example.com" | buku -a -
```

## Searching Bookmarks

### 1. Simple Search (Any Keyword)

Search matches titles, URLs, and comments:

```bash
buku -s python
```

Output:

```text
1. Python.org - Official Home
   https://www.python.org
```

### 2. Search All Keywords (AND Logic)

All keywords must match:

```bash
buku -S python documentation
```

Only shows bookmarks with both "python" AND "documentation".

### 3. Search by Tag

Find all bookmarks with a specific tag:

```bash
buku -t dev
```

Shows all bookmarks tagged with "dev".

### 4. Substring Search (Exact Match)

Find exact string in titles/URLs:

```bash
buku --subs github.com
```

### 5. Regular Expression Search

Use regex for complex searches:

```bash
buku --regex "^https://.*\.edu$"
```

Finds all bookmarks from educational domains (.edu).

## Updating Bookmarks

### 1. Update Specific Bookmark

Edit bookmark #3 interactively:

```bash
buku -w 3
```

Your editor opens with the bookmark data.

### 2. Update Bookmark Fields

Change title, tags, or comments:

```bash
buku -u 3 --title "New Title" --tag "newtag"
```

### 3. Refresh All Titles and Descriptions

Auto-fetch fresh titles from webpages:

```bash
buku --refresh
```

Useful after a long time to update stale metadata.

### 4. Update Multiple Bookmarks

Update all bookmarks matching a search:

```bash
buku -s python -u --tag "lang:python"
```

## Deleting Bookmarks

### 1. Delete Single Bookmark

```bash
buku -d 3
```

Deletes bookmark #3 with confirmation.

### 2. Delete Multiple Bookmarks

```bash
buku -d 1 2 3
```

Deletes bookmarks #1, #2, and #3.

### 3. Delete Range

```bash
buku -d 5-10
```

Deletes bookmarks #5 through #10.

### 4. Delete All Bookmarks with a Tag

First, find them:

```bash
buku -t old
```

Then delete them:

```bash
buku -d $(buku -t old -p | cut -d. -f1)
```

### 5. Delete with Confirmation

Always requires confirmation (default):

```bash
buku -d 3
```

Press 'y' to confirm.

## Opening Bookmarks in Browser

### 1. Open a Specific Bookmark

```bash
buku -o 3
```

Opens bookmark #3 in your default browser.

### 2. Open Search Result

```bash
buku -s github -o
```

Searches for "github" and opens the first matching bookmark.

### 3. Open Multiple Bookmarks

```bash
buku -o 1 2 3
```

Opens bookmarks #1, #2, and #3 in separate tabs.

## Copying URLs

### 1. Copy URL to Clipboard

```bash
buku -p 3 | grep "^http" | xclip -selection clipboard
```

Or using simpler syntax:

```bash
buku -p 3 | head -2 | tail -1 | xclip -selection clipboard
```

### 2. Copy URL from Search Result

```bash
buku -s github | grep "^http" | xclip -selection clipboard
```

### 3. Bash Function for Quick Copy

Add to your `~/.bashrc` or `~/.zshrc`:

```bash
bukucopy() {
  local id=$1
  buku -p "$id" | grep "^http" | xclip -selection clipboard
  echo "URL copied to clipboard!"
}
```

Then use: `bukucopy 3`

## Viewing Bookmarks

### 1. List All Bookmarks

```bash
buku -p
```

Shows all bookmarks with index, title, URL, and tags.

### 2. List with Details

```bash
buku -p --nc
```

Shows additional details (no color formatting).

### 3. Show Random Bookmark

```bash
buku -p | shuf | head -1
```

Great for discovering bookmarks you've forgotten about!

### 4. Show Bookmarks with Specific Tag

```bash
buku -t dev -p
```

Lists all bookmarks tagged "dev".

## Combining Operations

### Example 1: Search and Update All Results

Find all "tutorial" bookmarks and add a "learning" tag:

```bash
buku -s tutorial -u --tag "learning"
```

### Example 2: Search and Open

Find Python documentation and open it:

```bash
buku -s "python documentation" -o
```

### Example 3: Import, Tag, and Export

1. Import bookmarks: `buku -i bookmarks.html`
2. Tag them: `buku -u 1-20 --tag "imported"`
3. Export: `buku -e bookmarks-tagged.html -f html`

## Performance Tips

- Use `buku -S` (all keywords) for narrower, faster searches
- Use `-t` for tag searches (fastest lookup)
- Use `--regex` for complex pattern matching
- Cache frequently used searches in a shell alias or function

## Keyboard Shortcuts with Suggestions

If you've set the alias `alias b='buku --suggest'`, use:

```bash
b github
```

This opens an interactive suggestion mode where you can select from matching bookmarks.

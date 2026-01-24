# Getting Started with Buku

## Installation Verification

First, verify that buku is installed:

```bash
buku --version
```

You should see the version number (e.g., `buku 4.8`).

If buku is not installed, you can install it via:

- **Nix** (recommended): `home.packages = [ pkgs.buku ]`
- **pip**: `pip3 install buku`
- **Homebrew** (macOS): `brew install buku`
- **apt** (Ubuntu/Debian): `apt install buku`

## Setting Up Your Editor

Buku uses an external editor for creating and editing bookmarks. You need to
set the `EDITOR` environment variable to your preferred editor.

### Common Editors

**Vim** (powerful, steep learning curve):

```bash
export EDITOR=vim
```

**Nano** (beginner-friendly):

```bash
export EDITOR=nano
```

**Gedit** (GUI, Ubuntu/GNOME):

```bash
export EDITOR=gedit
```

**macvim** (GUI, macOS):

```bash
export EDITOR=macvim
```

**VS Code**:

```bash
export EDITOR="code --wait"
```

### Make It Permanent

Add your preferred editor to your shell configuration file (`~/.bashrc`,
`~/.zshrc`, etc.):

```bash
export EDITOR=vim  # Replace vim with your choice
```

Then reload your shell:

```bash
source ~/.bashrc  # or source ~/.zshrc
```

## Your First Bookmark

Creating your first bookmark opens your editor to add metadata:

```bash
buku -a https://www.wikipedia.org "Wikipedia" "reference" "knowledge"
```

Breaking this down:

- `buku -a` = Add a new bookmark
- `https://www.wikipedia.org` = The URL
- `"Wikipedia"` = Title (optional; buku fetches it if omitted)
- `"reference" "knowledge"` = Tags (optional, comma-separated or
  space-separated)

The editor opens, showing:

```text
[URL and metadata preview]
[Add your comments here - optional]
```

Save and exit your editor to confirm.

### Simpler First Bookmark

If you just want to add a URL without tags:

```bash
buku -a https://github.com
```

Buku automatically fetches the title from the webpage.

## Viewing Your Bookmarks

### View All Bookmarks

```bash
buku -p
```

Output example:

```text
1. GitHub: Where the world builds software
   https://github.com
   Tags: dev,code

2. Wikipedia
   https://www.wikipedia.org
   Tags: reference,knowledge
```

### View a Specific Bookmark

```bash
buku -p 1
```

This shows bookmark #1 in detail.

## Quick Search

Search for bookmarks by keyword:

```bash
buku -s github
```

The search is full-text, matching titles, URLs, and comments.

### Search with Multiple Keywords (All Must Match)

```bash
buku -S github code
```

The `-S` flag requires all keywords to be present.

## Helpful Alias

Add this to your shell configuration for faster access:

```bash
alias b='buku --suggest'
```

Now you can use `b` instead of `buku` for quick suggestions and searches.
This is particularly useful for opening bookmarks:

```bash
b github  # Shows matching bookmarks with suggestions
```

## Next Steps

Now that you're set up, explore:

1. **Daily Workflows** (`references/daily-workflows.md`) - Learn how to add,
   update, delete, and search bookmarks efficiently
2. **Organize with Tags** (`references/organize-bookmarks.md`) - Master tagging
   strategies and tag operators
3. **Import & Export** (`references/migrate-bookmarks.md`) - Import from your
   browser or export for backup

## Common Issues

- **Editor won't open**: Check that `EDITOR` is set correctly (`echo $EDITOR`)
- **Bookmark URL fetch fails**: Try adding the title manually:
  `buku -a URL "Your Title"`
- **Database not found**: Default location is `~/.local/share/buku/bookmarks.db`

For more help, see `references/troubleshooting.md`.

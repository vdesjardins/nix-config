# Tag Management Reference

Listing, filtering, organizing, and color-coding tags in timewarrior.

## List All Tags

**See all tags with usage count:**

```bash
timew tags
```

**Output:**

```text
development    42
project-alpha  28
code-review    15
meetings       12
team-beta       8
```

**See tags for this week only:**

```bash
timew tags :week
```

**See tags for a specific date range:**

```bash
timew tags from 2025-01-15 to 2025-01-19
```

**See tags for yesterday:**

```bash
timew tags yesterday
```

---

## Tag Discovery and Naming Consistency

**Check for duplicate/similar tags:**

```bash
# List all tags and scan manually
timew tags :week

# Use grep to find potential issues
timew tags | grep -i dev    # Find all dev-related tags
timew tags | grep -i alpha  # Find all alpha-related tags
```

**Export full tag list with intervals:**

```bash
# See all tags and which intervals use them
timew export :week | jq '.[] | .tags' | sort | uniq
```

---

## Tag Color Configuration

Assign colors to tags for better visual organization in reports.

**Set a single color:**

```bash
timew config tags.development.color "blue"
timew config tags.meetings.color "red"
timew config tags.billable.color "green"
```

**Set foreground and background colors:**

```bash
timew config tags.urgent.color "white on red"
timew config tags.completed.color "black on yellow"
```

**Use RGB color codes:**

```bash
# rgb123 format (each digit 0-5)
timew config tags.project-alpha.color "rgb345"
timew config tags.team-beta.color "rgb543"
```

**Valid color names:**

- Basic: `black`, `red`, `green`, `yellow`, `blue`, `magenta`, `cyan`,
  `white`
- Extended: `gray8`, `gray9`, `gray10`, `gray11`, `gray12`, `gray13`,
  `gray14`, `gray15`

**View all configured colors:**

```bash
timew show | grep "tags\."
```

**View a specific tag's color:**

```bash
timew show | grep "tags\.development"
```

---

## Tag Filtering and Search

**Find tags used in a time period:**

```bash
# Last week
timew tags :lastweek

# This month
timew tags :month

# Specific range
timew tags from 2025-01-01 to 2025-01-31
```

**Find intervals with a specific tag:**

```bash
# Show all entries tagged "development" this week
timew export :week | jq '.[] | select(.tags[] == "development")'

# Count occurrences
timew export :week | jq '[.[] | select(.tags[] == "development")] | length'
```

**Find similar tags (pattern matching):**

```bash
# Find all tags containing "dev"
timew tags :week | grep dev

# Find all tags containing "project"
timew tags :week | grep project
```

---

## Tag Consistency Checks

**Find variations in tag names:**

```bash
# Look for potential duplicates (case sensitivity)
timew export :week | jq -r '.[] | .tags[]' | sort | uniq -i

# Find numeric variations
timew tags :week | grep -E 'dev|development'
```

**Standardize tag names across intervals:**

Example: You have both "dev" and "development" and want to standardize to
"development".

1. **Find all intervals with the old tag:**

```bash
timew export :week | jq '.[] | select(.tags[] == "dev")'
```

2. **Get their IDs:**

```bash
timew summary :week :ids | grep -B1 dev
```

3. **Update the tags:**

```bash
# For each interval @ID, add new tag and remove old
timew tag @5 development
timew untag @5 dev

timew tag @10 development
timew untag @10 dev
```

4. **Verify:**

```bash
timew tags :week
# "dev" should now be gone
```

---

## Advanced Tag Queries

**Get total hours per tag:**

```bash
timew export :week | jq -r '.[] | .tags[]' | sort | uniq -c
```

**Find tags with most/least usage:**

```bash
# Most used
timew tags :week | head -1

# Least used
timew tags :week | tail -1
```

**Export tag hierarchy (projects vs activities):**

```bash
# Example: split project tags (project-*) from activity tags
timew export :week | jq -r '.[] | .tags[]' | grep -E '^project-' | \
  sort | uniq

# Get activity tags only
timew export :week | jq -r '.[] | .tags[]' | grep -vE '^project-' | \
  sort | uniq
```

---

## Quick Tag Reference

| Need | Command |
|------|---------|
| List all tags | `timew tags` |
| List this week's tags | `timew tags :week` |
| Set tag color | `timew config tags.NAME.color "COLOR"` |
| View all colors | `timew show \| grep "tags\."` |
| Find tag variations | `timew tags \| grep PATTERN` |
| Get tag usage count | `timew tags :week` |
| Find intervals with tag | `timew export :week \| jq '.[] \| select(.tags[] == "TAG")'` |
| Add tag to entry | `timew tag @ID newtag` |
| Remove tag from entry | `timew untag @ID oldtag` |

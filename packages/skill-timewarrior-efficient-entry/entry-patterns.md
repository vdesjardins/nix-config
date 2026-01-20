# Entry Patterns Reference

Detailed command examples for the 5 efficient entry techniques from the
main skill.

## Pattern 1: Query Existing Tags

**Command:**

```bash
timew tags :week
```

**Output:**

```text
development    15
project-alpha   8
code-review     6
meetings        4
team-beta       3
```

**Use:** See exact tag names and spelling before entering new data.

**Variations:**

```bash
# Today's tags
timew tags :day

# All tags ever used
timew tags

# Tags for specific date range
timew tags from 2025-01-15 to 2025-01-19
```

---

## Pattern 2: Copy Tags from Recent Work (Rapid Same-Day Entry)

**Scenario:** You need to log 3 activities in 5 minutes.

### Discover recent tags

```bash
timew export :day | grep -o '"tags":\[[^]]*\]' | head -5
```

### Use those exact tags

```bash
timew start 9am development project-alpha
timew stop
timew start 11am code-review team-beta
timew stop
timew start 1pm development project-alpha
```

**Key:** You're reusing proven names, not inventing.

---

## Pattern 3: Backfill with Pattern Matching

**Scenario:** You forgot to log yesterday. Need times + tags.

### Step 1: Query a similar day for pattern

```bash
timew report 2025-01-18 rc.columns=start,end,tags
```

**Output:**

```text
Start                End                  Tags
---
2025-01-18T09:00:00  2025-01-18T12:00:00  development
                                          project-alpha
2025-01-18T12:00:00  2025-01-18T13:00:00  break
2025-01-18T13:00:00  2025-01-18T17:00:00  development
                                          project-alpha
```

### Step 2: Enter yesterday using this pattern

```bash
# Morning work
timew track 2025-01-19T09:00:00 - 2025-01-19T12:00:00 \
  development project-alpha

# Break
timew track 2025-01-19T12:00:00 - 2025-01-19T13:00:00 \
  break

# Afternoon work
timew track 2025-01-19T13:00:00 - 2025-01-19T17:00:00 \
  development project-alpha
```

### Step 3: Verify

```bash
timew report 2025-01-19
```

---

## Pattern 4: Fill Gaps with Existing Tags Only

**Scenario:** Your week has gaps. Fill them without creating placeholders.

### Check the day's tags

```bash
timew summary :day monday
```

### Fill gaps > 30 min using those tags

```bash
# Identified gap: 12-2pm between dev sessions
timew track 12:00 - 14:00 development project-alpha

# Identified gap: 11-1pm after meeting
timew track 11:00 - 13:00 project-alpha

# Identified gap: afternoon (use best guess)
timew track 14:00 - 16:00 development
```

**Key rules:**

- Only fill gaps > 30 minutes
- Only use tags already on that day
- Never create placeholder tags (`buffer`, `misc`, `admin`)
- Skip ambiguous gaps (leave them)

---

## Pattern 5: Bulk Verify Before Friday EOD

### Step 1: List all tags used this week

```bash
timew tags :week
```

### Step 2: Scan for duplicates/typos

```bash
# Look for variations like:
# - dev / development
# - alpha / project-alpha
# - ProjectAlpha / project-alpha
# (Different cases or spellings)
```

### Step 3: If you find duplicates, fix them

Find entries with the wrong tag:

```bash
timew export :week | jq '.[] | select(.tags[] == "dev")'
```

Get the interval IDs:

```bash
timew summary :week :ids | grep dev
```

Fix the tags:

```bash
# Say you found @5 and @10 with wrong tag "dev"
timew tag @5 development
timew untag @5 dev

timew tag @10 development
timew untag @10 dev
```

### Step 4: Verify the fix

```bash
timew tags :week
# Now "dev" should be gone
```

---

## Quick Command Reference

| Need | Command |
|------|---------|
| See all tags this week | `timew tags :week` |
| See tags for specific day | `timew tags :day monday` |
| Query a pattern day | `timew report 2025-01-18 rc.columns=start,end,tags` |
| Track time block | `timew track START - END tag1 tag2` |
| Find entries with a tag | `timew export :week \| jq '.[] \| select(.tags[] == "TAG")'` |
| Get interval IDs | `timew summary :week :ids` |
| Add tag to interval | `timew tag @ID newtag` |
| Remove tag from interval | `timew untag @ID oldtag` |
| Check for all tags | `timew tags :week` |

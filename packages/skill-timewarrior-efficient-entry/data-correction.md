# Data Correction Reference

Fixing, modifying, and managing timewarrior entries.

## Modify Interval Times

**Change the start time of an interval:**

```bash
timew modify @2 start 9:00am
```

**Change the end time:**

```bash
timew modify @2 end 5:00pm
```

**Modify with auto-fill (adjusts adjacent intervals to prevent overlap):**

```bash
timew modify @2 start 9:00am :fill
```

---

## Adjust Interval Duration

**Add time to an interval:**

```bash
# Add 30 minutes
timew lengthen @2 30mins

# Add 1 hour
timew lengthen @2 1hour
```

**Subtract time from an interval:**

```bash
# Remove 15 minutes
timew shorten @2 15mins

# Remove 2 hours
timew shorten @2 2hours
```

---

## Delete Intervals

**Delete a single interval:**

```bash
timew delete @2
```

**Delete multiple intervals:**

```bash
timew delete @2 @5 @10
```

### Warning: Data Loss

Deleted entries cannot be easily recovered. Use `timew undo` immediately if
you delete by mistake.

**Safe deletion practice:**

```bash
# 1. Verify what you're deleting
timew summary :ids :tags | grep @2

# 2. Delete
timew delete @2

# 3. If wrong, immediately undo (before any other command)
timew undo
```

---

## Add/Modify Tags on Existing Entries

**Add a tag to an interval:**

```bash
timew tag @5 billable
```

**Add multiple tags to one interval:**

```bash
timew tag @5 billable backend review
```

**Add multiple tags to multiple intervals:**

```bash
timew tag @2 @5 @10 review
```

**Remove a tag from an interval:**

```bash
timew untag @5 billable
```

**Remove multiple tags:**

```bash
timew untag @5 billable internal
```

---

## Annotate Intervals

**Add a note to an interval:**

```bash
timew annotate @2 "Team standup meeting"
```

**View annotations:**

```bash
timew summary :week :annotations
```

---

## Handle Overlapping Intervals

**Scenario:** You started a new entry without stopping the previous one.

**What happens:** Timewarrior closes the previous interval and starts a new
one.

**Example:**

```bash
# You forgot to stop at noon
timew start 2pm development
# Timewarrior automatically closes morning entry at 2pm
# and starts new entry at 2pm
```

**To adjust overlaps manually:**

```bash
# Use :adjust hint when modifying
timew modify @2 start 9:00am :adjust

# This adjusts adjacent intervals to prevent overlap
```

---

## Undo Recent Changes

**Undo the last command:**

```bash
timew undo
```

**Important:** Undo only works immediately after a command. Once you run
another command, the previous change is committed.

**Safe workflow:**

```bash
timew delete @2
# Immediately after, if wrong:
timew undo

# But if you run any other command, undo won't help
timew summary  # Now undo is no longer possible
```

---

## Bulk Corrections

**Find and fix all instances of a wrong tag:**

```bash
# 1. Find intervals with wrong tag
timew export :week | jq '.[] | select(.tags[] == "oldtag")'

# 2. Get their IDs
timew summary :week :ids | grep oldtag

# 3. Fix each one
timew tag @5 newtag
timew untag @5 oldtag

timew tag @10 newtag
timew untag @10 oldtag
```

**Move an interval to a different day:**

```bash
# 1. Get the entry details
timew export | jq '.[] | select(.id == 5)'

# 2. Delete it
timew delete @5

# 3. Re-enter on the correct day
timew track 2025-01-20T09:00:00 - 2025-01-20T12:00:00 \
  development project-alpha
```

---

## Export and Reimport (Advanced Bulk Fixes)

**Export all data:**

```bash
timew export > backup.json
```

**Edit the backup** (if you're comfortable with JSON):

```bash
# Fix multiple tags at once
# Update timestamps
# Then reimport by copying entries back
```

**Import entries** (by re-entering them):

```bash
# Timewarrior doesn't have a direct import command
# Instead, use the exported data to manually re-enter
# with corrected values
```

---

## Quick Correction Reference

| Need | Command |
|------|---------|
| Modify start time | `timew modify @ID start TIME` |
| Modify end time | `timew modify @ID end TIME` |
| Add time | `timew lengthen @ID DURATIONmins` |
| Remove time | `timew shorten @ID DURATIONmins` |
| Delete entry | `timew delete @ID` |
| Add tag | `timew tag @ID tag1 tag2` |
| Remove tag | `timew untag @ID tag1 tag2` |
| Add note | `timew annotate @ID "note"` |
| Undo last change | `timew undo` |
| Find overlaps | `timew summary` (scan visually) |
| Fix overlap | `timew modify @ID start TIME :adjust` |

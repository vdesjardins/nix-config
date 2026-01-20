---
name: timewarrior-efficient-entry
description: >
  Use when you need to quickly log work activities and maintain
  consistent tags without duplicates or gaps
license: Apache-2.0
compatibility: Requires timewarrior (timew) command-line tool
metadata:
  author: vdesjardins
  version: "1.0"
---

# Efficient Time Entry with Timewarrior

Fast, consistent time tracking: avoid tag chaos, time guessing, and
duplicate entries through a proven 5-step workflow.

## When to Use This Skill

- ✅ You need to log work quickly but want consistency by Friday
- ✅ You're backfilling yesterday/last week but can't remember exact times
- ✅ You have gaps in your week and need to fill them with accurate tags
- ✅ You're tired and might create duplicate tag names

## When NOT to Use This Skill

- ❌ You're doing real-time tracking (just `timew start` as you work)
- ❌ You need detailed historical reconciliation (use full reference docs)
- ❌ You're analyzing trends (use analysis reports)

## The Core Problem

Without discipline, agents under time pressure:

1. Skip tag discovery → `dev`, `development`, `DEV` all in use by Friday
2. Invent times → backfilled data doesn't match actual patterns
3. Create placeholder tags → `buffer`, `misc`, `admin` pollute the list
4. Guess-and-fix later → tag mismatches discovered hours later
5. Leave unmeasured gaps → incomplete daily totals

## The 5-Step Efficient Entry Workflow

### Step 1: Query Existing Tags BEFORE Entering New Data

```bash
timew tags :week
```

**Why:** Takes 5 seconds. Prevents tag name chaos. You'll see exactly what
tags you've been using.

**What you do:** Note the exact spelling, case, and format
(e.g., `development` not `dev`).

### Step 2: For Rapid Same-Day Entry, Copy Tags from Recent Work

**Scenario:** You have 5 minutes before a meeting. Log 3 activities today.

```bash
# Find exact tag names from similar recent work
timew export :day | grep -o '"tags":\[[^]]*\]' | head -5

# Then use those EXACT names when entering new entries
timew start 9am development project-alpha
timew stop
timew start 11am code-review team-beta
```

**Key:** You're reusing proven tag names, not inventing new ones.

### Step 3: For Backfill (Yesterday/Last Week), Query the Pattern Day

**Scenario:** You forgot to log yesterday. You need times AND tags.

```bash
# Check a similar day from this week for both times and tags
timew report 2025-01-18 rc.columns=start,end,tags

# Then match that pattern for yesterday
timew track 2025-01-19T09:00:00 - 2025-01-19T12:00:00 development project-alpha
timew track 2025-01-19T13:00:00 - 2025-01-19T17:00:00 development project-alpha
```

**Key:** You're matching existing patterns, not guessing new times. If you
can't remember exact times, use the anchors you DO remember (meeting times,
when you left).

### Step 4: Fill Gaps ONLY with Existing Tags (No Placeholders)

**Scenario:** Your week has gaps between logged sessions.

```bash
# Check which tags dominated the day
timew summary :day monday

# Fill gaps > 30 min using tags from that day only
timew track 12:00 - 14:00 development    # Gap after morning dev
timew track 11:00 - 13:00 project-alpha  # Gap with context from work

# Skip gaps < 30 min (context-switching overhead not worth tracking)
```

**Key:** Never create `buffer`, `context-switch`, or `admin` tags.
Reuse what you know.

### Step 5: Bulk Verify Before Friday EOD

```bash
# See all tags you've used this week
timew tags :week

# Look for duplicates, typos, variations
# (e.g., "dev" vs "development", "alpha" vs "project-alpha")

# Check for placeholder tags you forgot about
timew summary :week
```

**Fix discovered duplicates:**

```bash
# Find all entries with misspelled tag
timew export :week | grep -o '"dev"'

# Modify entries to use correct tag
timew tag @5 development
timew untag @5 dev
```

## Quick Reference: The Workflow Matrix

| Scenario | Step 1 | Step 2 | Step 3 | Step 4 |
|----------|--------|---------|---------|---------|
| **Rapid same-day entry** | Query tags (5s) | Copy recent tags | — | — |
| **Backfill yesterday** | Query tags (5s) | — | Query pattern day | Verify consistency |
| **Fill week gaps** | Query tags (5s) | — | — | Fill with existing tags only |
| **Friday verification** | `timew tags :week` | — | — | Check for duplicates |

## Common Mistakes (And How the Workflow Prevents Them)

| Mistake | Why It Happens | Workflow Fix |
|---------|----------------|--------------|
| `dev` + `development` coexist | Skip Step 1 (tag query) | Always query first |
| Backfilled times are ±2 hours off | Invent times (Step 3) | Query a pattern day instead |
| `buffer`, `misc` pollute tags | Create placeholders (Step 4) | Reuse only existing tags |
| Discover duplicates Friday PM | Guess-and-fix approach | Do Step 5: bulk verify |
| Gaps in daily totals | Skip filling (Step 4) | Fill gaps > 30min only |

## When Each Step Takes Under 1 Minute

- **Step 1 (Query tags):** 5 seconds → `timew tags :week`
- **Step 2 (Copy tags):** 10 seconds → `timew export :day | grep tags`
- **Step 3 (Query pattern):** 10 seconds → `timew report SIMILAR_DAY`
- **Step 4 (Fill gaps):** 30 seconds → 3-4 `timew track` commands
- **Step 5 (Verify):** 20 seconds → `timew tags :week` and scan for typos

**Total for a complete backfill + gap fill:** ~2 minutes instead of 10+
minutes of guessing and fixing.

## References

For detailed commands and advanced operations, see:

- `entry-patterns.md` – Step-by-step commands for each scenario
- `tag-management.md` – List, filter, and color-code tags
- `data-correction.md` – Modify, delete, undo operations
- `analysis-reports.md` – Query and reporting commands
- `complete-reference.md` – Full timewarrior command reference

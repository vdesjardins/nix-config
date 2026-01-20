---
name: timewarrior
description: Comprehensive guide to timewarrior time tracking with
  step-by-step instructions for adding entries, managing tags, filling gaps,
  and generating time reports. Use timewarrior commands for time tracking, tag
  management, and work analytics.
license: Apache-2.0
compatibility: Requires timewarrior (timew) command-line tool
metadata:
  author: vdesjardins
  version: "1.0"
---

# Timewarrior Time Tracking

Guide for effective time tracking with Timewarrior, a command-line time
tracker for monitoring work activities and generating productivity reports.

## Overview

Timewarrior is a command-line time tracking application that helps you
record time spent on different activities, organize them with tags, and
generate comprehensive reports.

## Getting Started

### Verify Timewarrior Installation

Before using any timewarrior workflow, verify that timewarrior is installed:

```bash
timew --version
```

If this fails, timewarrior needs to be installed through your package
manager or Nix.

## Core Concepts

### Intervals

An **interval** is a tracked time period with:

- **Start time**: When tracking began
- **End time**: When tracking ended
- **Tags**: Labels for categorizing the work
- **ID**: A unique identifier (prefixed with `@`) used to reference intervals

### Tags

Tags are labels you apply to intervals to categorize work. Each interval can
have multiple tags.

Examples of useful tags:

- **Project names**: `project-alpha`, `client-beta`
- **Activity types**: `development`, `meetings`, `documentation`, `review`
- **Billable status**: `billable`, `internal`
- **Context**: `remote`, `office`, `travel`

## Common Tasks

### 1. Add a New Entry (Start Tracking)

Start tracking time for a current activity:

```bash
timew start <tag1> <tag2> ...
```

**Examples:**

```bash
# Start tracking with simple tags
timew start development project-alpha

# Start tracking with tags that contain spaces (use quotes)
timew start "project alpha" development backend

# Start tracking at a specific time
timew start 9:30am development
```

The tracker will begin at the current time (or specified time) and continue
until you stop it.

### 2. Stop Tracking

Stop the currently active interval:

```bash
timew stop
```

This closes the open interval with the current time.

### 3. Add Tags to Existing Entries

Add tags to an already-tracked interval using its ID:

```bash
timew tag @<id> <tag1> <tag2> ...
```

**Examples:**

```bash
# Show IDs first
timew summary :ids

# Add tags to interval @5
timew tag @5 billable backend

# Add multiple tags to multiple intervals
timew tag @2 @5 @10 review documentation
```

### 4. Remove Tags from Entries

Remove specific tags from an interval:

```bash
timew untag @<id> <tag1> <tag2> ...
```

**Examples:**

```bash
# Remove a single tag
timew untag @5 billable

# Remove multiple tags from multiple intervals
timew untag @2 @5 @10 review
```

### 5. Fill Gaps with Period Entries

Fill time gaps between intervals with general period entries:

```bash
# First view intervals with IDs
timew summary :ids :week

# Fill the gap with "morning" activity
timew fill @2
```

The `fill` command extends an interval to fill the gap to adjacent
intervals.

For filling specific time periods (morning, afternoon, etc.), use the
track command:

```bash
# Track time for a specific period
timew track 9am - 12pm morning

# Track afternoon session
timew track 1pm - 5pm afternoon

# Track with tags
timew track 9am - 12pm morning development
```

### 6. Get Weekly Time Totals by Tags

Generate a summary report for the week filtered by specific tags:

```bash
# View week summary with tag breakdown
timew summary :week <tag1> <tag2> ...

# View with IDs and tags shown
timew summary :week :ids :tags

# View all tags available
timew tags

# Generate week summary for specific tags
timew summary :week development design
```

**Output example:**

```text
Wk  Date       Day ID Tags    Start      End        Time   Total
--- ---------- --- -- -------- -------- -------- ------- -------
W03 2025-01-20 Mon @1 dev      9:00:00 12:00:00 3:00:00
              @2 design 1:00:00  4:00:00 3:00:00
              @3 meetings 4:00:00 5:00:00 1:00:00 7:00:00
    2025-01-21 Tue @4 dev     8:30:00 12:30:00 4:00:00
              @5 review   1:00:00  2:00:00 1:00:00 5:00:00
    ...
```

## Time Ranges and Querying

### Supported Time Range Hints

Timewarrior supports convenient range shortcuts:

| Hint | Meaning |
|------|---------|
| `:today` or `:day` | Current day (24 hours) |
| `:yesterday` | Previous day |
| `:week` | Current week (Mon-Sun) |
| `:lastweek` | Previous week |
| `:month` | Current month |
| `:lastmonth` | Previous month |
| `:quarter` | Current quarter |
| `:year` | Current year |
| `:all` | All tracked time |
| `:fortnight` | Current week + last week |

**Examples:**

```bash
# Current day summary
timew summary :day

# This week summary
timew summary :week

# Last month summary
timew summary :lastmonth

# All tracked time
timew summary :all
```

### Date Formats

Timewarrior supports ISO-8601 date formats and friendly date expressions:

**ISO-8601 formats:**

- `2025-01-20` - Date only
- `2025-01-20T14:30:00` - Full datetime
- `2025-01-20T14:30:00Z` - UTC timezone

**Friendly formats:**

- `now` - Current date and time
- `today` - Current date at midnight
- `yesterday` - Previous day at midnight
- `tomorrow` - Next day at midnight
- `monday`, `tuesday`, etc. - Previous named day
- `8am`, `2:30pm` - Time expressions
- `sopd`, `eopd` - Start/end of previous day
- `sow`, `eow` - Start/end of current week
- `som`, `eom` - Start/end of current month

**Examples:**

```bash
# Track from a specific date
timew track 2025-01-20 2pm - 2025-01-20 5pm development

# Use friendly date ranges
timew summary from monday to friday

# Track for a duration
timew track "1 hour ago" - now development
```

### Interval Syntax

Timewarrior accepts flexible interval specifications:

```bash
# Duration-based intervals
timew track "from 2 hours ago for 1 hour" development

# Date range intervals
timew track "from monday to friday" project-alpha

# Explicit start and end
timew track "9:00am - 5:00pm" work development
```

## Viewing Data

### Summary Report

Display a summary of tracked time:

```bash
# Default (today)
timew summary

# Specific range
timew summary :week :ids :tags

# Specific tags only
timew summary :week development design
```

Useful summary hints:

- `:ids` - Show interval ID numbers (needed to modify intervals)
- `:tags` - Show tag column
- `:annotations` - Show annotations (if added)

### Weekly Report

Display a week chart:

```bash
timew week

# With tags
timew week development design
```

### Day Report

Display a day chart:

```bash
timew day

# For specific day
timew day yesterday
```

## Managing Tags

Timewarrior provides comprehensive tag management capabilities to help you
organize, search, and analyze your time tracking data.

### List All Tags

View all tags that have been used in your time tracking:

```bash
# Display all tags with usage count
timew tags

# Show tags used this week
timew tags :week

# Show tags used in a specific date range
timew tags from monday to friday

# Show tags for a specific month
timew tags :month
```

The output shows each tag and how many times it has been used. This is useful
for understanding your tagging patterns and ensuring consistent tag naming.

### Search and Filter Tags

Use timewarrior to filter and discover which tags were active during specific
periods:

```bash
# Find tags used during last week
timew tags :lastweek

# Discover tags used on a specific day
timew tags yesterday

# Show tags for a date range
timew tags from 2025-01-01 to 2025-01-31

# Filter intervals by tag and see the count
timew summary :week development | grep development
```

This helps you answer questions like "What tags did I use in the morning?" or
"Which projects were active last month?"

### Tag Color Configuration

Timewarrior supports assigning colors to tags for better visual organization in
reports. This is especially useful for color-coding by project, priority, or
billability.

#### Setting Tag Colors

Configure color for a tag using the `config` command:

```bash
# Assign a single color
timew config tags.development.color "blue"
timew config tags.meetings.color "red"
timew config tags.billable.color "green"

# Assign background and foreground colors
timew config tags.urgent.color "white on red"
timew config tags.completed.color "black on yellow"

# Use RGB color codes
timew config tags.project-alpha.color "rgb345"
```

#### Valid Color Formats

- **Named colors**: `black`, `white`, `red`, `green`, `blue`, `yellow`, `cyan`,
  `magenta`, `gray8` (and others)
- **With background**: `white on blue`, `black on green` (format: foreground on
  background)
- **RGB codes**: `rgb123` where each digit is 0-5 (e.g., `rgb345`)

#### Viewing Tag Configuration

View all configured colors:

```bash
# Show all color configurations
timew show | grep "tags\."

# Or search for a specific tag's color
timew show | grep "tags\.development"
```

### Advanced Tag Analysis

Use Python scripts included with this skill to perform advanced tag analysis and
search. These scripts provide JSON output for AI consumption and human-readable
table/report formats.

#### Fuzzy Tag Search

Find tags even with typos or partial matches:

```bash
# Fuzzy search for 'development' (handles typos like 'deve', 'devlop')
./scripts/tag_fuzzy_search.py "deve"

# Output shows exact match and similar tags
{
  "query": "deve",
  "matches": [
    {
      "tag": "development",
      "similarity": 0.95,
      "usage_count": 15,
      "exact_match": true
    },
    {
      "tag": "design",
      "similarity": 0.67,
      "usage_count": 8,
      "exact_match": false
    }
  ],
  "exact_match_found": true,
  "total_available_tags": 12
}
```

Useful for:

- Finding tags quickly without remembering exact names
- Handling typos in tag queries
- Discovering similar tag names you might have forgotten about

#### Tag Usage Statistics

Analyze which tags consume the most time and how frequently they're used:

```bash
# Get tag statistics for this week
./scripts/tag_analyzer.py --period week

# Get statistics for a specific tag
./scripts/tag_analyzer.py --tag development

# Get statistics as a table (human-readable)
./scripts/tag_analyzer.py --period month --format table

# Output example (JSON)
{
  "tags": [
    {
      "name": "development",
      "count": 15,
      "total_hours": 42.5
    },
    {
      "name": "meetings",
      "count": 8,
      "total_hours": 3.2
    }
  ],
  "total_intervals": 25,
  "unique_tags": 5,
  "total_hours": 52.8
}
```

#### Comprehensive Tag Reports

Generate detailed reports showing trends and insights:

```bash
# Generate week report
./scripts/tag_report.py --period week

# Generate report for a specific tag
./scripts/tag_report.py --tag development

# Show report in human-readable format
./scripts/tag_report.py --period month --format report

# Output example (JSON with trends)
{
  "summary": {
    "total_intervals": 25,
    "total_hours": 52.8,
    "unique_tags": 5,
    "days_tracked": 7,
    "avg_hours_per_day": 7.5
  },
  "by_tag": [
    {
      "name": "development",
      "count": 15,
      "total_hours": 42.5,
      "days_worked": 6,
      "avg_hours_per_session": 2.83
    }
  ],
  "trends": {
    "most_used_tag": "development",
    "most_productive_day": "2025-01-20",
    "busiest_day": "2025-01-21"
  }
}
```

### Using Grep for Tag Search

For quick command-line filtering, use `grep` with timewarrior export:

```bash
# Find all intervals with 'development' tag
timew export :week | grep -i development

# Count how many times each tag appears
timew export :month | grep -o '"tags":\[[^]]*\]' | wc -l

# List all unique tags (simple method)
timew export | grep -o '"name":"[^"]*"' | sort | uniq
```

## Advanced Operations

### Modify Interval Times

Adjust start or end times of an interval:

```bash
# Change start time
timew modify @2 start 9:00am

# Change end time
timew modify @2 end 5:00pm

# Use :fill hint to auto-extend to adjacent intervals
timew modify @2 start 9:00am :fill
```

### Lengthen or Shorten Intervals

Adjust interval duration:

```bash
# Add 30 minutes
timew lengthen @2 30mins

# Subtract 15 minutes
timew shorten @2 15mins
```

### Delete Intervals

Remove an interval completely:

```bash
timew delete @2
```

### Annotate Intervals

Add notes to intervals:

```bash
timew annotate @2 "Team standup meeting"
```

### Export Data

Export tracked time in JSON format:

```bash
timew export :week
```

### Undo Changes

Undo the last timewarrior command:

```bash
timew undo
```

## Configuration

View current configuration:

```bash
timew show
```

Set configuration values:

```bash
timew config <name> <value>
```

**Common configurations:**

- `reports.summary.range` - Default range for summary (e.g., `week`, `day`)
- `reports.summary.tags` - Show tags in summary (on/off)
- `reports.summary.ids` - Show IDs in summary (on/off)

## Workflow Examples

### Example 1: Track a Day of Work

```bash
# Start morning work at 9 AM
timew start 9am development project-alpha

# Stop at noon
timew stop

# Lunch break and meeting
timew track 12pm - 1:30pm meetings

# Afternoon work
timew start 1:30pm development project-alpha
timew stop

# View the day
timew summary :day :ids :tags
```

### Example 2: Add Tags to Past Work

```bash
# View this week's entries with IDs
timew summary :week :ids :tags

# Realize @5 should be marked billable
timew tag @5 billable

# And remove an incorrect tag
timew untag @5 internal
```

### Example 3: Generate Weekly Report

```bash
# Get a week summary with all details
timew summary :week :ids :tags

# Get just development hours this week
timew summary :week development

# Get development and design hours
timew summary :week development design

# See total by tag
timew tags
```

### Example 4: Fill Daily Gaps

```bash
# View the day with IDs
timew summary :day :ids

# Track specific time periods
timew track "9am - 12pm" morning development
timew track "1pm - 5pm" afternoon development

# View filled day
timew summary :day :ids
```

## Best Practices

1. **Use Descriptive Tags** - Use tags that clearly indicate project and
   activity type
2. **Tag Immediately** - Tag intervals as you track to avoid forgetting context
3. **Regular Review** - Review weekly summaries to ensure accurate tracking
4. **Consistent Naming** - Use consistent tag names across all intervals
5. **Fill Gaps** - Use `track` and `fill` to account for all working hours
6. **Backdate When Needed** - Use specific times for intervals tracked after
   the fact
7. **Export Regularly** - Export data periodically for backup or analysis

## Troubleshooting

### Overlapping Intervals

If you start tracking while an interval is open, it closes the previous one:

```bash
# If you forgot to stop, start a new entry with correct time
timew start 2pm development

# This closes the previous interval at 2pm and starts a new one
```

### Modify Overlapping Entries

Use the `:adjust` hint to handle overlaps:

```bash
timew modify @2 start 9:00am :adjust
```

### Restore Mistaken Changes

Use `undo` to revert the last operation:

```bash
timew undo
```

## References

- [Timewarrior Official Documentation](https://timewarrior.net/docs/)
- [Timewarrior Help](https://timewarrior.net/docs/help/)
- [Time Syntax Reference](https://timewarrior.net/docs/syntax/)
- [Date Formats](https://timewarrior.net/docs/reference/timew-dates.7/)
- [Hints](https://timewarrior.net/docs/reference/timew-hints.7/)
- [Configuration](https://timewarrior.net/docs/reference/timew-config.1/)

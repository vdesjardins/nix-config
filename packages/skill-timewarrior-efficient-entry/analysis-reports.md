# Analysis and Reports Reference

Querying, reporting, and extracting insights from your timewarrior data.

## Summary Reports

**View today's summary:**

```bash
timew summary
```

**View this week's summary:**

```bash
timew summary :week
```

**View with interval IDs:**

```bash
timew summary :week :ids
```

**View with tags column:**

```bash
timew summary :week :ids :tags
```

**View with annotations:**

```bash
timew summary :week :annotations
```

**View specific tags only:**

```bash
# Development work this week
timew summary :week development

# Multiple tags
timew summary :week development design meetings
```

---

## Time Range Summaries

**Last week:**

```bash
timew summary :lastweek
```

**This month:**

```bash
timew summary :month
```

**Last month:**

```bash
timew summary :lastmonth
```

**This quarter:**

```bash
timew summary :quarter
```

**This year:**

```bash
timew summary :year
```

**All tracked time:**

```bash
timew summary :all
```

**Fortnight (this week + last week):**

```bash
timew summary :fortnight
```

**Custom date range:**

```bash
timew summary from 2025-01-15 to 2025-01-19
```

---

## Weekly and Daily Reports

**View week as a chart:**

```bash
timew week
```

**View week for specific day:**

```bash
timew week 2025-01-20
```

**View week for specific tags:**

```bash
timew week development design
```

**View day as a chart:**

```bash
timew day
```

**View yesterday's day:**

```bash
timew day yesterday
```

**View specific day:**

```bash
timew day 2025-01-20
```

---

## Export Data

**Export all data as JSON:**

```bash
timew export
```

**Export specific time range:**

```bash
timew export :week
timew export :month
timew export from 2025-01-15 to 2025-01-19
```

**Save to file:**

```bash
timew export :week > weekly-report.json
```

---

## Advanced Querying with jq

**Find all entries with a specific tag:**

```bash
timew export :week | jq '.[] | select(.tags[] == "development")'
```

**Count entries per tag:**

```bash
timew export :week | jq -r '.[] | .tags[]' | sort | uniq -c
```

**Total hours per tag:**

```bash
timew export :week | jq -r '.[] | .tags[]' | sort | uniq | while read tag; do
  count=$(timew export :week | jq "[.[] | select(.tags[] == \"$tag\")] | \
    length")
  echo "$tag: $count entries"
done
```

**Find longest entry:**

```bash
timew export :week | jq -s 'max_by(.duration)'
```

**Find shortest entry:**

```bash
timew export :week | jq -s 'min_by(.duration)'
```

**Get total duration this week:**

```bash
timew export :week | jq '[.[] | .duration] | add'
```

**Show entries with no tags:**

```bash
timew export :week | jq '.[] | select(.tags | length == 0)'
```

**Find entries older than a week:**

```bash
timew export :all | jq '.[] | select(.start < now - 604800)'
```

---

## Tag Analysis

**See all tags used:**

```bash
timew tags
```

**See tags for a time period:**

```bash
timew tags :week
timew tags :month
timew tags from 2025-01-15 to 2025-01-19
```

**Find most-used tags:**

```bash
timew tags :week | head -5
```

**Find least-used tags:**

```bash
timew tags :week | tail -5
```

---

## Configuration and Settings

**View current configuration:**

```bash
timew show
```

**View specific configuration:**

```bash
timew show | grep "reports.summary"
```

**Change default summary range:**

```bash
timew config reports.summary.range week
```

**Show tags in summary by default:**

```bash
timew config reports.summary.tags on
```

**Show IDs in summary by default:**

```bash
timew config reports.summary.ids on
```

---

## Backup and Restore

**Create a backup:**

```bash
timew export > timewarrior-backup-$(date +%Y%m%d).json
```

**Backup full configuration and data:**

```bash
cp -r ~/.timewarrior/ ~/.timewarrior-backup-$(date +%Y%m%d)/
```

**Restore from JSON backup:**

```bash
# Note: You'd need to manually re-enter, or use a script
# For now, keep the JSON for reference
```

**Restore full backup:**

```bash
cp -r ~/.timewarrior-backup-DATE/ ~/.timewarrior/
```

---

## Quick Reports Reference

| Need | Command |
|------|---------|
| Today's summary | `timew summary` |
| Week summary | `timew summary :week` |
| With IDs and tags | `timew summary :week :ids :tags` |
| Month summary | `timew summary :month` |
| Week chart | `timew week` |
| Day chart | `timew day` |
| Export as JSON | `timew export :week` |
| List all tags | `timew tags` |
| Tag totals | `timew tags :week` |
| View config | `timew show` |
| Backup data | `timew export > backup.json` |

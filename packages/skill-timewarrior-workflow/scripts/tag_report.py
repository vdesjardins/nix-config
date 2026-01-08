#!/usr/bin/env python3
"""
Tag Report for Timewarrior

Generates comprehensive tag statistics and reports.
Outputs JSON by default, or human-readable reports with --format report.

Usage:
    python tag_report.py [options]

Options:
    --period PERIOD       Time period: day, week, month, year, all (default: week)
    --tag TAG            Filter results for specific tag
    --from DATE          Start date (ISO format: YYYY-MM-DD)
    --to DATE            End date (ISO format: YYYY-MM-DD)
    --format FORMAT      Output format: json, report (default: json)
    --sort FIELD         Sort by: name, count, hours (default: hours)
    --help              Show this help message
"""

import json
import subprocess
import sys
from datetime import datetime


def check_timewarrior():
    """Verify timewarrior is installed."""
    try:
        subprocess.run(
            ["timew", "--version"],
            capture_output=True,
            check=True,
            timeout=5,
        )
        return True
    except (subprocess.CalledProcessError, FileNotFoundError, subprocess.TimeoutExpired):
        return False


def get_timewarrior_data(period="week", tag=None, from_date=None, to_date=None):
    """
    Fetch timewarrior data via export and parse it.

    Args:
        period: Time period (day, week, month, year, all)
        tag: Optional tag filter
        from_date: Optional start date
        to_date: Optional end date

    Returns:
        Tuple of (intervals_list, error_message)
    """
    try:
        # Build command
        cmd = ["timew", "export", f":{period}"]

        if from_date:
            cmd.append(f"from {from_date}")
        if to_date:
            cmd.append(f"to {to_date}")
        if tag:
            cmd.append(tag)

        result = subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            check=True,
            timeout=10,
        )

        if not result.stdout.strip():
            return [], None

        # Parse JSON output
        data = json.loads(result.stdout)
        return data if isinstance(data, list) else [], None

    except subprocess.CalledProcessError as e:
        return [], f"Timewarrior command failed: {e.stderr}"
    except json.JSONDecodeError:
        return [], "Failed to parse timewarrior output"
    except subprocess.TimeoutExpired:
        return [], "Timewarrior command timed out"
    except Exception as e:
        return [], f"Error fetching data: {str(e)}"


def generate_report(intervals, sort_by="hours"):
    """
    Generate comprehensive tag report from intervals.

    Args:
        intervals: List of interval dicts
        sort_by: Sort field (name, count, hours)

    Returns:
        Comprehensive report dict
    """
    tag_stats = {}
    daily_stats = {}
    total_hours = 0

    for interval in intervals:
        tags = interval.get("tags", [])
        start = interval.get("start", "")
        end = interval.get("end", "")

        # Calculate duration in hours
        try:
            if start and end:
                start_dt = datetime.fromisoformat(start.replace("Z", "+00:00"))
                end_dt = datetime.fromisoformat(end.replace("Z", "+00:00"))
                duration_hours = (end_dt - start_dt).total_seconds() / 3600
                day_key = start_dt.strftime("%Y-%m-%d")
            else:
                duration_hours = 0
                day_key = None
        except (ValueError, AttributeError):
            duration_hours = 0
            day_key = None

        # Update daily stats
        if day_key:
            if day_key not in daily_stats:
                daily_stats[day_key] = {"count": 0, "hours": 0.0, "tags": set()}
            daily_stats[day_key]["count"] += 1
            daily_stats[day_key]["hours"] += duration_hours
            for tag in tags:
                daily_stats[day_key]["tags"].add(tag)

        # Update tag stats
        for tag in tags:
            if tag not in tag_stats:
                tag_stats[tag] = {"count": 0, "total_hours": 0.0, "days": set()}
            tag_stats[tag]["count"] += 1
            tag_stats[tag]["total_hours"] += duration_hours
            if day_key:
                tag_stats[tag]["days"].add(day_key)

        total_hours += duration_hours

    # Convert to sorted list
    sort_key_map = {
        "name": lambda x: x[0].lower(),
        "count": lambda x: -x[1]["count"],
        "hours": lambda x: -x[1]["total_hours"],
    }
    sort_key = sort_key_map.get(sort_by, sort_key_map["hours"])

    tags_list = [
        {
            "name": tag,
            "count": stats["count"],
            "total_hours": round(stats["total_hours"], 2),
            "days_worked": len(stats["days"]),
            "avg_hours_per_session": round(
                stats["total_hours"] / stats["count"], 2
            )
            if stats["count"] > 0
            else 0,
        }
        for tag, stats in sorted(tag_stats.items(), key=sort_key)
    ]

    # Convert daily stats for JSON serialization
    by_day = {
        day: {
            "count": stats["count"],
            "hours": round(stats["hours"], 2),
            "tags": sorted(list(stats["tags"])),
        }
        for day, stats in sorted(daily_stats.items())
    }

    return {
        "summary": {
            "total_intervals": sum(len(v) for v in intervals),
            "total_hours": round(total_hours, 2),
            "unique_tags": len(tag_stats),
            "days_tracked": len(daily_stats),
            "avg_hours_per_day": round(total_hours / len(daily_stats), 2)
            if daily_stats
            else 0,
        },
        "by_tag": tags_list,
        "by_day": by_day,
        "trends": {
            "most_used_tag": tags_list[0]["name"] if tags_list else None,
            "most_productive_day": max(by_day.items(), key=lambda x: x[1]["hours"])[0]
            if by_day
            else None,
            "busiest_day": max(by_day.items(), key=lambda x: x[1]["count"])[0]
            if by_day
            else None,
        },
    }


def format_report(report):
    """Format report as human-readable text."""
    lines = []

    # Summary section
    summary = report["summary"]
    lines.append("=" * 60)
    lines.append("TIME TRACKING REPORT")
    lines.append("=" * 60)
    lines.append("")
    lines.append(f"Total Intervals: {summary['total_intervals']}")
    lines.append(f"Total Hours:     {summary['total_hours']}")
    lines.append(f"Unique Tags:     {summary['unique_tags']}")
    lines.append(f"Days Tracked:    {summary['days_tracked']}")
    lines.append(f"Avg Hours/Day:   {summary['avg_hours_per_day']}")
    lines.append("")

    # By tag section
    lines.append("=" * 60)
    lines.append("BY TAG")
    lines.append("=" * 60)
    lines.append(
        f"{'Tag':<30} {'Count':>6} {'Hours':>8} {'Avg/Session':>12}"
    )
    lines.append("-" * 60)

    for tag_info in report["by_tag"]:
        lines.append(
            f"{tag_info['name']:<30} {tag_info['count']:>6} "
            f"{tag_info['total_hours']:>8.1f} {tag_info['avg_hours_per_session']:>12.1f}"
        )

    lines.append("")

    # Trends section
    lines.append("=" * 60)
    lines.append("TRENDS & INSIGHTS")
    lines.append("=" * 60)

    trends = report["trends"]
    if trends["most_used_tag"]:
        lines.append(f"Most Used Tag:      {trends['most_used_tag']}")
    if trends["most_productive_day"]:
        lines.append(f"Most Productive:    {trends['most_productive_day']}")
    if trends["busiest_day"]:
        lines.append(f"Busiest Day:        {trends['busiest_day']}")

    return "\n".join(lines)


def main():
    """Main entry point."""
    # Parse arguments
    period = "week"
    tag = None
    from_date = None
    to_date = None
    output_format = "json"
    sort_by = "hours"

    i = 1
    while i < len(sys.argv):
        arg = sys.argv[i]
        if arg == "--help":
            print(__doc__)
            sys.exit(0)
        elif arg == "--period" and i + 1 < len(sys.argv):
            period = sys.argv[i + 1]
            i += 2
        elif arg == "--tag" and i + 1 < len(sys.argv):
            tag = sys.argv[i + 1]
            i += 2
        elif arg == "--from" and i + 1 < len(sys.argv):
            from_date = sys.argv[i + 1]
            i += 2
        elif arg == "--to" and i + 1 < len(sys.argv):
            to_date = sys.argv[i + 1]
            i += 2
        elif arg == "--format" and i + 1 < len(sys.argv):
            output_format = sys.argv[i + 1]
            i += 2
        elif arg == "--sort" and i + 1 < len(sys.argv):
            sort_by = sys.argv[i + 1]
            i += 2
        else:
            i += 1

    # Check timewarrior availability
    if not check_timewarrior():
        error = {
            "error": "Timewarrior is not installed or not available",
            "command": "timew",
        }
        print(json.dumps(error), file=sys.stderr)
        sys.exit(1)

    # Fetch and analyze data
    intervals, error = get_timewarrior_data(period, tag, from_date, to_date)
    if error:
        error_obj = {"error": error}
        print(json.dumps(error_obj), file=sys.stderr)
        sys.exit(1)

    report = generate_report(intervals, sort_by)

    # Output results
    if output_format == "report":
        print(format_report(report))
    else:
        print(json.dumps(report, indent=2))


if __name__ == "__main__":
    main()

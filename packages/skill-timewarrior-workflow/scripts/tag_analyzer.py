#!/usr/bin/env python3
"""
Tag Analyzer for Timewarrior

Analyzes tag usage patterns and generates statistics.
Outputs JSON by default, or human-readable tables with --format table.

Usage:
    python tag_analyzer.py [options]

Options:
    --period PERIOD       Time period: day, week, month, year, all (default: week)
    --tag TAG            Filter results for specific tag
    --from DATE          Start date (ISO format: YYYY-MM-DD)
    --to DATE            End date (ISO format: YYYY-MM-DD)
    --format FORMAT      Output format: json, table (default: json)
    --help              Show this help message
"""

import json
import subprocess
import sys
from datetime import datetime, timedelta
from pathlib import Path


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


def analyze_tags(intervals):
    """
    Analyze tag usage from intervals.

    Returns:
        Dict with tag statistics
    """
    tag_stats = {}
    total_intervals = len(intervals)

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
            else:
                duration_hours = 0
        except (ValueError, AttributeError):
            duration_hours = 0

        for tag in tags:
            if tag not in tag_stats:
                tag_stats[tag] = {"count": 0, "total_hours": 0.0}
            tag_stats[tag]["count"] += 1
            tag_stats[tag]["total_hours"] += duration_hours

    # Convert to sorted list
    tags_list = [
        {"name": tag, **stats}
        for tag, stats in sorted(
            tag_stats.items(), key=lambda x: x[1]["count"], reverse=True
        )
    ]

    return {
        "tags": tags_list,
        "total_intervals": total_intervals,
        "unique_tags": len(tag_stats),
        "total_hours": sum(t["total_hours"] for t in tags_list),
    }


def format_table(analysis):
    """Format analysis results as a table."""
    if not analysis["tags"]:
        return "No tags found for the specified period."

    # Header
    lines = [
        "Tag                          Count  Hours",
        "-" * 50,
    ]

    # Rows
    for tag_info in analysis["tags"]:
        tag = tag_info["name"]
        count = tag_info["count"]
        hours = tag_info["total_hours"]
        lines.append(f"{tag:<28} {count:>5}  {hours:>8.1f}")

    # Footer
    lines.append("-" * 50)
    lines.append(
        f"{'Total':<28} {analysis['total_intervals']:>5}  "
        f"{analysis['total_hours']:>8.1f}"
    )

    return "\n".join(lines)


def main():
    """Main entry point."""
    # Parse arguments
    period = "week"
    tag = None
    from_date = None
    to_date = None
    output_format = "json"

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

    analysis = analyze_tags(intervals)

    # Output results
    if output_format == "table":
        print(format_table(analysis))
    else:
        print(json.dumps(analysis, indent=2))


if __name__ == "__main__":
    main()

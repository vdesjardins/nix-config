#!/usr/bin/env python3
"""
Tag Fuzzy Search for Timewarrior

Performs fuzzy matching on tags to help find similar or misspelled tags.
Uses difflib for similarity matching - no external dependencies.

Usage:
    python tag_fuzzy_search.py QUERY [options]

Arguments:
    QUERY                 Search query or tag name

Options:
    --threshold FLOAT     Similarity threshold 0.0-1.0 (default: 0.6)
    --limit N            Maximum results to return (default: 10)
    --format FORMAT      Output format: json, list (default: json)
    --help              Show this help message
"""

import difflib
import json
import subprocess
import sys
from collections import Counter


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


def get_all_tags():
    """
    Fetch all tags from timewarrior.

    Returns:
        Tuple of (tags_dict, error_message)
        tags_dict format: {"tag_name": usage_count, ...}
    """
    try:
        result = subprocess.run(
            ["timew", "export"],
            capture_output=True,
            text=True,
            check=True,
            timeout=10,
        )

        if not result.stdout.strip():
            return {}, None

        data = json.loads(result.stdout)
        if not isinstance(data, list):
            return {}, None

        # Count tag usage
        tag_counts = Counter()
        for interval in data:
            tags = interval.get("tags", [])
            for tag in tags:
                tag_counts[tag] += 1

        return dict(tag_counts), None

    except subprocess.CalledProcessError as e:
        return {}, f"Timewarrior command failed: {e.stderr}"
    except json.JSONDecodeError:
        return {}, "Failed to parse timewarrior output"
    except subprocess.TimeoutExpired:
        return {}, "Timewarrior command timed out"
    except Exception as e:
        return {}, f"Error fetching tags: {str(e)}"


def fuzzy_search_tags(query, all_tags, threshold=0.6, limit=10):
    """
    Perform fuzzy search on tags.

    Args:
        query: Search string
        all_tags: Dict of {tag: count}
        threshold: Minimum similarity score (0.0-1.0)
        limit: Maximum number of results

    Returns:
        List of matching tags with similarity scores
    """
    if not all_tags:
        return []

    tag_names = list(all_tags.keys())

    # Check for exact match first
    exact_match = None
    if query.lower() in [t.lower() for t in tag_names]:
        exact_match = next(t for t in tag_names if t.lower() == query.lower())

    # Get close matches
    close_matches = difflib.get_close_matches(
        query, tag_names, n=limit, cutoff=threshold
    )

    # Build results
    results = []
    seen = set()

    # Add exact match first if found
    if exact_match and exact_match not in seen:
        results.append(
            {
                "tag": exact_match,
                "similarity": 1.0,
                "usage_count": all_tags[exact_match],
                "exact_match": True,
            }
        )
        seen.add(exact_match)

    # Add close matches
    for tag in close_matches:
        if tag not in seen:
            similarity = difflib.SequenceMatcher(None, query.lower(), tag.lower()).ratio()
            results.append(
                {
                    "tag": tag,
                    "similarity": round(similarity, 2),
                    "usage_count": all_tags[tag],
                    "exact_match": False,
                }
            )
            seen.add(tag)

    return results


def format_list(results):
    """Format results as a list."""
    if not results:
        return "No matching tags found."

    lines = []
    for result in results:
        match_type = " (exact)" if result["exact_match"] else ""
        lines.append(
            f"{result['tag']:<30} "
            f"similarity: {result['similarity']:.0%} "
            f"usage: {result['usage_count']}{match_type}"
        )

    return "\n".join(lines)


def main():
    """Main entry point."""
    if len(sys.argv) < 2:
        print(__doc__, file=sys.stderr)
        sys.exit(1)

    # Parse arguments
    query = sys.argv[1]
    threshold = 0.6
    limit = 10
    output_format = "json"

    i = 2
    while i < len(sys.argv):
        arg = sys.argv[i]
        if arg == "--help":
            print(__doc__)
            sys.exit(0)
        elif arg == "--threshold" and i + 1 < len(sys.argv):
            try:
                threshold = float(sys.argv[i + 1])
                threshold = max(0.0, min(1.0, threshold))
                i += 2
            except ValueError:
                i += 2
        elif arg == "--limit" and i + 1 < len(sys.argv):
            try:
                limit = int(sys.argv[i + 1])
                i += 2
            except ValueError:
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

    # Fetch all tags
    all_tags, error = get_all_tags()
    if error:
        error_obj = {"error": error}
        print(json.dumps(error_obj), file=sys.stderr)
        sys.exit(1)

    # Perform search
    results = fuzzy_search_tags(query, all_tags, threshold, limit)

    # Output results
    if output_format == "list":
        print(format_list(results))
    else:
        output = {
            "query": query,
            "matches": results,
            "exact_match_found": any(r["exact_match"] for r in results),
            "total_available_tags": len(all_tags),
        }
        print(json.dumps(output, indent=2))


if __name__ == "__main__":
    main()

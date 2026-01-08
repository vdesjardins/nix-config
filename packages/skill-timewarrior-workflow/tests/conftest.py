"""Conftest for pytest fixtures and configuration."""

import json
import sys
from pathlib import Path
from typing import Dict, List, Any
import pytest


# Get the parent directory (skill root)
SKILL_ROOT = Path(__file__).parent.parent
SCRIPTS_DIR = SKILL_ROOT / "scripts"


@pytest.fixture
def sample_timewarrior_data() -> List[Dict[str, Any]]:
    """Sample timewarrior export data for testing."""
    return [
        {
            "id": 1,
            "start": "2025-01-20T08:00:00Z",
            "end": "2025-01-20T10:30:00Z",
            "tags": ["development", "project-alpha"],
        },
        {
            "id": 2,
            "start": "2025-01-20T10:45:00Z",
            "end": "2025-01-20T12:00:00Z",
            "tags": ["meetings"],
        },
        {
            "id": 3,
            "start": "2025-01-20T13:00:00Z",
            "end": "2025-01-20T17:00:00Z",
            "tags": ["development", "project-alpha"],
        },
        {
            "id": 4,
            "start": "2025-01-21T08:00:00Z",
            "end": "2025-01-21T09:30:00Z",
            "tags": ["research"],
        },
        {
            "id": 5,
            "start": "2025-01-21T10:00:00Z",
            "end": "2025-01-21T12:00:00Z",
            "tags": ["development"],
        },
    ]


@pytest.fixture
def all_tags_from_sample(sample_timewarrior_data) -> List[str]:
    """Extract all unique tags from sample data."""
    tags = set()
    for interval in sample_timewarrior_data:
        tags.update(interval.get("tags", []))
    return sorted(list(tags))

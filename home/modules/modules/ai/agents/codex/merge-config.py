"""Merge Nix-owned Codex settings without making runtime state read-only."""

from collections.abc import MutableMapping
import json
import os
from pathlib import Path
import sys
import tempfile

import tomlkit


def reconcile(current, previous, desired):
    """Remove stale owned keys, preserve unmanaged keys, and apply Nix values."""
    for key in previous:
        if key not in desired:
            current.pop(key, None)
    for key, value in desired.items():
        if isinstance(value, dict):
            if key not in current or not isinstance(current[key], MutableMapping):
                current[key] = tomlkit.table()
            old = previous.get(key, {})
            reconcile(current[key], old if isinstance(old, dict) else {}, value)
        else:
            current[key] = value


def atomic_write(path, content):
    """Replace the directory entry, never follow a Nix-store symlink on write."""
    descriptor, temporary = tempfile.mkstemp(prefix=f".{path.name}.", dir=path.parent)
    try:
        with os.fdopen(descriptor, "w") as output:
            output.write(content)
        os.replace(temporary, path)
    finally:
        if os.path.exists(temporary):
            os.unlink(temporary)


def merge(source, destination, manifest):
    desired = tomlkit.parse(source.read_text()).unwrap()
    current = tomlkit.parse(destination.read_text()) if destination.exists() else tomlkit.document()
    previous = json.loads(manifest.read_text()) if manifest.exists() else {}
    reconcile(current, previous, desired)
    destination.parent.mkdir(mode=0o700, parents=True, exist_ok=True)
    atomic_write(destination, tomlkit.dumps(current))
    atomic_write(manifest, json.dumps(desired))


if __name__ == "__main__":
    merge(*(Path(argument) for argument in sys.argv[1:]))

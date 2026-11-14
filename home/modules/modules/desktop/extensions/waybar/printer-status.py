"""Report the local CUPS queue to Waybar without submitting print jobs."""

import html
import json
import sys
from urllib.parse import unquote, urlparse

import cups

PRINTER_STATES = {3: "Idle", 4: "Printing", 5: "Stopped"}
JOB_STATES = {
    3: "Pending",
    4: "Held",
    5: "Printing",
    6: "Stopped",
    7: "Cancelled",
    8: "Aborted",
    9: "Completed",
}


def status(printer):
    connection = cups.Connection(host="localhost", port=631)
    printer = printer or connection.getDefault()
    if not printer:
        raise RuntimeError("No default printer configured")

    attributes = connection.getPrinterAttributes(printer)
    state = attributes.get("printer-state", 3)
    jobs = connection.getJobs(
        which_jobs="not-completed",
        my_jobs=True,
        requested_attributes=["job-name", "job-state", "job-printer-uri"],
    )
    jobs = {
        job_id: job
        for job_id, job in jobs.items()
        if unquote(urlparse(job.get("job-printer-uri", "")).path).rsplit("/", 1)[-1]
        == printer
    }
    accepting = attributes.get("printer-is-accepting-jobs", True)
    label = PRINTER_STATES.get(state, "Unknown")
    css_class = "stopped" if state == 5 or not accepting else "idle"
    if css_class != "stopped":
        css_class = "printing" if state == 4 else "pending" if jobs else "idle"

    tooltip = [f"{printer}: {label}", f"Your queued documents: {len(jobs)}"]
    if not accepting:
        tooltip.append("Not accepting new jobs")
    reasons = attributes.get("printer-state-reasons", [])
    if isinstance(reasons, str):
        reasons = [reasons]
    tooltip.extend(reason for reason in reasons if reason != "none")
    message = attributes.get("printer-state-message", "")
    if message:
        tooltip.append(message)
    for job_id, job in sorted(jobs.items()):
        title = job.get("job-name", "Untitled")
        job_state = JOB_STATES.get(job.get("job-state"), "Unknown")
        tooltip.append(f"#{job_id}: {title} — {job_state}")

    return {
        "text": f"{len(jobs)} · {label}",
        "tooltip": html.escape("\n".join(tooltip)),
        "class": css_class,
    }


if __name__ == "__main__":
    try:
        result = status(sys.argv[1] if len(sys.argv) > 1 else "")
    except (cups.IPPError, RuntimeError, OSError) as error:
        result = {
            "text": "Unavailable",
            "tooltip": html.escape(f"Cannot query local CUPS: {error}"),
            "class": "unavailable",
        }
    print(json.dumps(result))

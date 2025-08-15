#!/usr/bin/env python3
"""
Daily System Monitoring Script

Environment Variables Required:
- WEBHOOK_PATH: Path to a file containing the Discord webhook URL.
- USER_ID: Discord user ID to mention in reports.

This script:
- Collects system errors, warnings, and usage statistics.
- Uploads long logs to a public paste service (Hastebin).
- Sends a daily summary report to a Discord channel.
"""

import os
import sys
import subprocess
import requests
import psutil
from datetime import datetime
import time


# Color constants for Discord embeds
COLOR_INFO = 3447003  # Blue
COLOR_WARNING = 16769024  # Yellow
COLOR_CRITICAL = 15548997  # Red


def read_file_safe(path, description):
    """Read a file safely, raising an error if it fails."""
    try:
        with open(path, "r") as f:
            return f.read().strip()
    except FileNotFoundError:
        sys.exit(f"ERROR: {description} file not found at {path}")
    except PermissionError:
        sys.exit(f"ERROR: No permission to read {description} at {path}")
    except Exception as e:
        sys.exit(f"ERROR: Failed to read {description} at {path}: {e}")


# Read environment variables
webhook_path = os.getenv("WEBHOOK_PATH")
user_id = os.getenv("USER_ID")

if not webhook_path or not user_id:
    sys.exit("ERROR: WEBHOOK_PATH and USER_ID must be set in the environment.")

webhook_url = read_file_safe(webhook_path, "webhook URL")
hostname = read_file_safe("/etc/hostname", "hostname")
date_str = datetime.now().strftime("%Y-%m-%d")

# Validate webhook URL file is not empty
if not webhook_url:
    sys.exit("ERROR: Webhook URL file is empty.")

# Validate USER_ID is numeric
if not user_id.isdigit():
    sys.exit("ERROR: USER_ID must be numeric.")


def send_discord(title, description, color, retries=3, delay=5):
    """Send an embedded message to a Discord channel, retrying on failure."""
    payload = {
        "content": f"<@{user_id}>",
        "embeds": [
            {
                "title": title,
                "description": description,
                "color": color,
                "timestamp": datetime.now().isoformat(),
                "footer": {"text": hostname},
            }
        ],
    }
    headers = {"Content-Type": "application/json"}

    last_exception = None
    for attempt in range(1, retries + 1):
        try:
            response = requests.post(
                webhook_url, json=payload, headers=headers, timeout=10
            )
            response.raise_for_status()
            return response.status_code
        except requests.exceptions.RequestException as e:
            last_exception = e
            if attempt < retries:
                print(
                    f"WARNING: Discord send failed (attempt {attempt}/{retries}), retrying in {delay}s..."
                )
                time.sleep(delay)
            else:
                sys.exit(
                    f"ERROR: Failed to send message to Discord after {retries} attempts: {last_exception}"
                )


def upload_to_hastebin(content):
    """Upload content to Hastebin (no auth required)."""
    try:
        response = requests.post(
            "https://hastebin.com/documents", data=content.encode("utf-8"), timeout=10
        )
        response.raise_for_status()
        json_resp = response.json()
        if "key" in json_resp:
            return f"https://hastebin.com/{json_resp['key']}"
        return "Unavailable"
    except requests.exceptions.RequestException:
        return "Unavailable"


def get_system_status():
    """Gather system error/warning logs, failed services, disk/memory usage, and load average."""
    errors = subprocess.check_output(
        ["journalctl", "--since", "yesterday", "--priority", "err", "--no-pager", "-q"],
        text=True,
    )
    warnings = subprocess.check_output(
        [
            "journalctl",
            "--since",
            "yesterday",
            "--priority",
            "warning",
            "--no-pager",
            "-q",
        ],
        text=True,
    )

    failed_services_output = subprocess.check_output(
        ["systemctl", "--failed", "--no-legend", "--no-pager"], text=True
    ).strip()
    failed_services_count = (
        0 if not failed_services_output else len(failed_services_output.split("\n"))
    )

    # Improved disk usage parsing
    df_output = subprocess.check_output(["df", "-h"], text=True)

    memory_usage = psutil.virtual_memory().percent
    load_avg = os.getloadavg()

    return (
        errors,
        warnings,
        failed_services_count,
        memory_usage,
        load_avg,
        failed_services_output,
    )


def build_report(
    errors,
    warnings,
    failed_services,
    memory_usage,
    load_avg,
    failed_services_output,
):
    """Create a formatted system report with severity status."""
    report = f"**Daily System Report - {date_str}**\n\n"
    status = "INFO"
    color = COLOR_INFO

    if errors or failed_services > 0:
        status = "CRITICAL"
        color = COLOR_CRITICAL
    elif float(disk_usage) > 90 or memory_usage > 90:
        status = "WARNING"
        color = COLOR_WARNING

    uptime_str = subprocess.check_output(["uptime", "-p"], text=True).strip()

    report += f"**System Status:** {status}\n"
    report += f"**Uptime:** {uptime_str}\n"
    report += f"**Load Average:** {', '.join(map(str, load_avg))}\n"
    report += f"**Memory Usage:** {memory_usage}%\n"
    report += f"**Disk Usage:** {disk_usage}%\n"
    report += f"**Failed Services:** {failed_services}\n\n"

    if errors:
        error_url = upload_to_hastebin(errors)
        report += f"**🚨 Critical Errors Found:**\n{error_url}\n\n"

    if failed_services > 0:
        report += f"**❌ Failed Services:**\n```\n{failed_services_output}\n```\n\n"

    if warnings:
        warning_url = upload_to_hastebin(warnings)
        report += f"**⚠ Recent Warnings:**\n{warning_url}\n\n"

    return report, color


def main():
    (
        errors,
        warnings,
        failed_services,
        memory_usage,
        load_avg,
        failed_services_output,
    ) = get_system_status()
    report, color = build_report(
        errors,
        warnings,
        failed_services,
        memory_usage,
        load_avg,
        failed_services_output,
    )
    send_discord(f"{hostname} - Daily System Report", report, color)
    print("Daily monitoring report sent to Discord.")


if __name__ == "__main__":
    main()

#!/usr/bin/env python3
"""
Daily System Monitoring Script

Environment Variables Required:
- WEBHOOK_PATH: Path to a file containing the Discord webhook URL.
- USER_ID: Discord user ID to mention in reports.

This script:
- Shows failed services without logs.
- Shows services with errors with their last few lines of logs.
- Shows services with warnings with their last few lines of logs.
- Sends a daily summary report to a Discord channel.
"""

import os
import sys
import subprocess
import requests
import psutil
import json
import logging
from datetime import datetime
import time
import tempfile
from collections import defaultdict

# Configure detailed logging
logging.basicConfig(
    level=logging.DEBUG,
    format="%(asctime)s - %(levelname)s - %(funcName)s:%(lineno)d - %(message)s",
    handlers=[logging.StreamHandler(sys.stdout)],
)

# Color constants for Discord embeds
COLOR_INFO = 3447003  # Blue
COLOR_WARNING = 16769024  # Yellow
COLOR_CRITICAL = 15548997  # Red


def read_file_safe(path, description):
    """Read a file safely, raising an error if it fails."""
    logging.info(f"Reading {description} from {path}")
    try:
        with open(path, "r") as f:
            content = f.read().strip()
            logging.debug(f"Successfully read {description}: {len(content)} characters")
            return content
    except FileNotFoundError:
        logging.error(f"{description} file not found at {path}")
        sys.exit(f"ERROR: {description} file not found at {path}")
    except PermissionError:
        logging.error(f"No permission to read {description} at {path}")
        sys.exit(f"ERROR: No permission to read {description} at {path}")
    except Exception as e:
        logging.error(f"Failed to read {description} at {path}: {e}")
        sys.exit(f"ERROR: Failed to read {description} at {path}: {e}")


def run_journalctl(args):
    """Run journalctl command and return output"""
    cmd = ["journalctl"] + args
    logging.info(f"Running command: {' '.join(cmd)}")

    try:
        result = subprocess.run(cmd, capture_output=True, text=True, check=True)
        output_length = len(result.stdout)
        logging.info(
            f"Command executed successfully, output length: {output_length} chars"
        )
        logging.debug(f"Command stderr: {result.stderr}")
        if output_length < 1000:  # Only log small outputs in full
            logging.debug(f"Command stdout (first 500 chars): {result.stdout[:500]}")
        return result.stdout
    except subprocess.CalledProcessError as e:
        logging.error(f"Error running journalctl: {e}")
        logging.error(f"Return code: {e.returncode}")
        logging.error(f"Stderr: {e.stderr}")
        return ""


def send_discord_with_files(
    title,
    description,
    color,
    error_services=None,
    warning_services=None,
    retries=3,
    delay=5,
):
    """Send an embedded message to Discord with optional file attachments."""
    logging.info(f"Sending Discord message with files: {title}")

    # Prepare the main payload
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

    files = {}
    temp_files = []

    try:
        # Create error log file if we have error services
        if error_services:
            logging.info(f"Creating error log file for {len(error_services)} services")
            error_content = f"Error Services Log - {date_str}\n"
            error_content += "=" * 50 + "\n\n"

            for service in error_services:
                logging.debug(f"Getting detailed error logs for {service}")
                service_errors = get_service_logs(service, "err", 5)  # 5 lines for file
                if service_errors:
                    error_content += f"{service}:\n"
                    error_content += "-" * len(service) + "\n"
                    error_content += service_errors + "\n\n"

            # Create temporary file
            error_file = tempfile.NamedTemporaryFile(
                mode="w", suffix=".txt", delete=False, prefix="errors_"
            )
            error_file.write(error_content)
            error_file.close()
            temp_files.append(error_file.name)

            files["errors.txt"] = open(error_file.name, "rb")
            logging.info(f"Created error log file: {error_file.name}")

        # Create warning log file if we have warning services
        if warning_services:
            logging.info(
                f"Creating warning log file for {len(warning_services)} services"
            )
            warning_content = f"Warning Services Log - {date_str}\n"
            warning_content += "=" * 50 + "\n\n"

            for service in warning_services:
                logging.debug(f"Getting detailed warning logs for {service}")
                service_warnings = get_service_logs(
                    service, "warning", 5
                )  # 5 lines for file
                if service_warnings:
                    warning_content += f"{service}:\n"
                    warning_content += "-" * len(service) + "\n"
                    warning_content += service_warnings + "\n\n"

            # Create temporary file
            warning_file = tempfile.NamedTemporaryFile(
                mode="w", suffix=".txt", delete=False, prefix="warnings_"
            )
            warning_file.write(warning_content)
            warning_file.close()
            temp_files.append(warning_file.name)

            files["warnings.txt"] = open(warning_file.name, "rb")
            logging.info(f"Created warning log file: {warning_file.name}")

        # Send the message with files
        last_exception = None
        for attempt in range(1, retries + 1):
            logging.debug(f"Discord send attempt {attempt}/{retries}")
            try:
                # Prepare the multipart form data
                data = {"payload_json": json.dumps(payload)}

                response = requests.post(
                    webhook_url, data=data, files=files, timeout=30
                )
                response.raise_for_status()
                logging.info(
                    f"Discord message sent successfully (status: {response.status_code})"
                )
                return response.status_code

            except requests.exceptions.RequestException as e:
                last_exception = e
                logging.warning(
                    f"Discord send failed (attempt {attempt}/{retries}): {e}"
                )
                if attempt < retries:
                    print(
                        f"WARNING: Discord send failed (attempt {attempt}/{retries}), retrying in {delay}s..."
                    )
                    time.sleep(delay)
                else:
                    logging.error(
                        f"Failed to send message to Discord after {retries} attempts: {last_exception}"
                    )
                    sys.exit(
                        f"ERROR: Failed to send message to Discord after {retries} attempts: {last_exception}"
                    )

    finally:
        # Clean up file handles and temporary files
        for file_handle in files.values():
            if hasattr(file_handle, "close"):
                file_handle.close()

        for temp_file_path in temp_files:
            try:
                os.unlink(temp_file_path)
                logging.debug(f"Deleted temporary file: {temp_file_path}")
            except OSError as e:
                logging.warning(
                    f"Failed to delete temporary file {temp_file_path}: {e}"
                )


def send_discord(title, description, color, retries=3, delay=5):
    """Send an embedded message to a Discord channel, retrying on failure (legacy function)."""
    return send_discord_with_files(
        title, description, color, None, None, retries, delay
    )


def get_services_with_logs(priority, time_period="yesterday"):
    """Get list of services that had logs at specified priority level"""
    logging.info(f"Getting services with {priority} logs since {time_period}")

    # Get logs in JSON format to parse service names reliably
    args = [
        "--since",
        time_period,
        f"--priority={priority}",
        "--output=json",
        "--no-pager",
    ]
    output = run_journalctl(args)

    if not output.strip():
        logging.warning(f"No {priority} logs found")
        return []

    services = set()
    lines_processed = 0
    json_parse_errors = 0

    for line in output.strip().split("\n"):
        if line.strip():
            lines_processed += 1
            try:
                log_entry = json.loads(line)
                logging.debug(f"Parsed log entry keys: {list(log_entry.keys())}")

                # Prioritize SYSLOG_IDENTIFIER first, then fall back to others
                service = (
                    log_entry.get("SYSLOG_IDENTIFIER")
                    or log_entry.get("_SYSTEMD_UNIT")
                    or log_entry.get("_COMM")
                )

                if service:
                    logging.debug(f"Found service identifier: '{service}' from entry")
                    if "systemd-coredump" not in service:
                        services.add(service)
                        logging.debug(
                            f"Added service: '{service}' (total unique services: {len(services)})"
                        )
                    else:
                        logging.debug(
                            f"Filtered out systemd-coredump service: '{service}'"
                        )
                else:
                    logging.debug("No service identifier found in log entry")

            except json.JSONDecodeError as e:
                json_parse_errors += 1
                logging.warning(f"Failed to parse JSON line {lines_processed}: {e}")
                logging.debug(f"Problematic line: {line[:100]}...")
                continue

    logging.info(f"Processed {lines_processed} {priority} log lines")
    logging.info(f"JSON parse errors: {json_parse_errors}")
    logging.info(f"Found {len(services)} unique services with {priority} logs")
    logging.debug(f"Services found: {sorted(services)}")

    return sorted(services)


def get_service_logs(service, priority, count=5, time_period="yesterday"):
    """Get the last N logs for a specific service at specified priority, showing only first line of each entry"""
    logging.info(
        f"Getting {priority} logs for service: '{service}' (last {count} entries)"
    )

    # Try to use the service name as both unit and identifier
    args = [
        "--since",
        time_period,
        f"--priority={priority}",
        "--no-pager",
        "-n",
        str(count),
    ]

    # First try as SYSLOG_IDENTIFIER
    identifier_args = args + ["SYSLOG_IDENTIFIER=" + service]
    logging.debug(f"Trying SYSLOG_IDENTIFIER approach for '{service}'")
    output = run_journalctl(identifier_args)

    # If no output, try as systemd unit
    if not output.strip():
        logging.debug(
            f"No output from SYSLOG_IDENTIFIER, trying as systemd unit for '{service}'"
        )
        unit_args = args + ["-u", service]
        output = run_journalctl(unit_args)

    if not output.strip():
        logging.warning(f"No {priority} logs found for service '{service}'")
        return ""

    logging.info(
        f"Found {len(output.strip().split(chr(10)))} lines of output for '{service}'"
    )

    # Process output to keep only first line of each log entry
    lines = output.strip().split("\n")
    processed_lines = []
    continuation_lines_filtered = 0

    for i, line in enumerate(lines):
        # Skip empty lines
        if not line.strip():
            logging.debug(f"Skipping empty line {i+1}")
            continue

        # Check if this line starts with a timestamp (new log entry)
        # Journalctl output typically starts with: "Aug 16 10:30:15" format
        if (
            len(line) > 15
            and line[3:4] == " "
            and line[6:7] == " "
            and line[9:10] == ":"
        ):
            processed_lines.append(line)
            logging.debug(f"Keeping line {i+1} (timestamp detected): {line[:60]}...")
        else:
            # If it doesn't start with timestamp, it's a continuation line - skip it
            continuation_lines_filtered += 1
            logging.debug(f"Filtering continuation line {i+1}: {line[:60]}...")

    logging.info(
        f"Processed {len(lines)} lines, kept {len(processed_lines)}, filtered {continuation_lines_filtered} continuation lines"
    )

    return "\n".join(processed_lines)


def get_failed_services():
    """Get list of failed systemd services"""
    logging.info("Getting failed systemd services")
    try:
        result = subprocess.run(
            ["systemctl", "--failed", "--no-legend", "--no-pager"],
            capture_output=True,
            text=True,
            check=True,
        )
        failed_services_output = result.stdout.strip()
        failed_services_count = (
            0 if not failed_services_output else len(failed_services_output.split("\n"))
        )
        logging.info(f"Found {failed_services_count} failed services")
        return failed_services_count, failed_services_output
    except subprocess.CalledProcessError as e:
        logging.error(f"Error getting failed services: {e}")
        return 0, ""


def get_system_status():
    """Gather system error/warning logs, failed services, disk/memory usage, and load average."""
    logging.info("Gathering comprehensive system status")

    # Get raw error and warning logs (no longer needed for Hastebin)
    # errors = run_journalctl(["--since", "yesterday", "--priority", "err", "--no-pager", "-q"])
    # warnings = run_journalctl(["--since", "yesterday", "--priority", "warning", "--no-pager", "-q"])

    # Get services with errors and warnings
    error_services = get_services_with_logs("err")
    warning_services = get_services_with_logs("warning")

    # Get failed services
    failed_services_count, failed_services_output = get_failed_services()

    # Get system metrics
    memory_usage = psutil.virtual_memory().percent
    logging.info(f"Current memory usage: {memory_usage}%")

    return (
        error_services,
        warning_services,
        failed_services_count,
        failed_services_output,
        memory_usage,
    )


def build_report(
    error_services,
    warning_services,
    failed_services_count,
    failed_services_output,
    memory_usage,
):
    """Create a formatted system report with severity status."""
    logging.info("Building comprehensive system report")

    report = f"**Daily System Report - {date_str}**\n\n"
    status = "INFO"
    color = COLOR_INFO

    if failed_services_count > 0 or error_services:
        status = "CRITICAL"
        color = COLOR_CRITICAL
    elif memory_usage > 90 or warning_services:
        status = "WARNING"
        color = COLOR_WARNING

    uptime_str = subprocess.check_output(["uptime"], text=True).strip()

    report += f"**System Status:** {status}\n"
    report += f"**Uptime:** {uptime_str}\n"
    report += f"**Memory Usage:** {memory_usage}%\n"
    report += f"**Failed Services:** {failed_services_count}\n"
    report += f"**Services with Errors:** {len(error_services)}\n"
    report += f"**Services with Warnings:** {len(warning_services)}\n\n"

    # Failed services (no logs, just list)
    if failed_services_count > 0:
        report += f"**❌ Failed Services:**\n```\n{failed_services_output}\n```\n\n"

    # Services with errors (just list the names)
    if error_services:
        report += f"**🚨 Services with Errors ({len(error_services)}):**\n"
        # Group services in lines of up to 3 for readability
        service_lines = []
        for i in range(0, len(error_services), 3):
            line_services = error_services[i : i + 3]
            service_lines.append(" • ".join(line_services))
        report += "\n".join(service_lines) + "\n\n"

    # Services with warnings (just list the names)
    if warning_services:
        report += f"**⚠ Services with Warnings ({len(warning_services)}):**\n"
        # Group services in lines of up to 3 for readability
        service_lines = []
        for i in range(0, len(warning_services), 3):
            line_services = warning_services[i : i + 3]
            service_lines.append(" • ".join(line_services))
        report += "\n".join(service_lines) + "\n\n"

    if error_services or warning_services:
        report += "📎 **Detailed logs attached as files**\n\n"

    logging.info(f"Report built successfully, length: {len(report)} characters")
    return report, color


def main():
    logging.info("=== Starting Daily System Monitoring ===")

    # Read environment variables
    global webhook_url, hostname, date_str, user_id

    webhook_path = os.getenv("WEBHOOK_PATH")
    user_id = os.getenv("USER_ID")

    if not webhook_path or not user_id:
        logging.error("WEBHOOK_PATH and USER_ID environment variables not set")
        sys.exit("ERROR: WEBHOOK_PATH and USER_ID must be set in the environment.")

    webhook_url = read_file_safe(webhook_path, "webhook URL")
    hostname = read_file_safe("/etc/hostname", "hostname")
    date_str = datetime.now().strftime("%Y-%m-%d")

    # Validate webhook URL file is not empty
    if not webhook_url:
        logging.error("Webhook URL file is empty")
        sys.exit("ERROR: Webhook URL file is empty.")

    # Validate USER_ID is numeric
    if not user_id.isdigit():
        logging.error("USER_ID is not numeric")
        sys.exit("ERROR: USER_ID must be numeric.")

    logging.info(f"Configuration validated - hostname: {hostname}, date: {date_str}")

    # Gather system status
    (
        error_services,
        warning_services,
        failed_services_count,
        failed_services_output,
        memory_usage,
    ) = get_system_status()

    # Build and send report with files
    report, color = build_report(
        error_services,
        warning_services,
        failed_services_count,
        failed_services_output,
        memory_usage,
    )

    # Send with file attachments if there are errors or warnings
    if error_services or warning_services:
        send_discord_with_files(
            f"{hostname} - Daily System Report",
            report,
            color,
            error_services if error_services else None,
            warning_services if warning_services else None,
        )
    else:
        send_discord(f"{hostname} - Daily System Report", report, color)
    print("Daily monitoring report sent to Discord.")
    logging.info("=== Daily System Monitoring Complete ===")


if __name__ == "__main__":
    main()

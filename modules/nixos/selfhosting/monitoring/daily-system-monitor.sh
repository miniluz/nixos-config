set -euo pipefail

TMPDIR=$(mktemp -d)

LC_ALL=C

FAILED_LOG="$TMPDIR/failed_services.log"
ERROR_LOG="$TMPDIR/error_services.log"
WARNING_LOG="$TMPDIR/warning_services.log"

# Helper to extract service names from journalctl JSON
get_services() {
  jq -r '(.SYSLOG_IDENTIFIER // ._SYSTEMD_UNIT // ._COMM) | select(type == "string" and contains("systemd-coredump") | not)' | sort -u
}

# Mapfile maps from STDIN into a Bash array. Sort -u sorts and removes duplicates
echo "Getting failed services..."
mapfile -t FAILED_SERVICES < <(systemctl --failed --no-legend --no-pager --output=json | jq -r '.[].unit' | sort -u)
mapfile -t ALL_ERROR_SERVICES < <(journalctl --since yesterday --priority=err --output=json --no-pager 2>/dev/null | get_services)
mapfile -t ALL_WARN_SERVICES  < <(journalctl --since yesterday --priority=warning --output=json --no-pager 2>/dev/null | get_services)

mapfile -t ERROR_SERVICES < <(printf '%s\n' "${ALL_ERROR_SERVICES[@]}" \
    | grep -vFxf <(printf '%s\n' "${FAILED_SERVICES[@]}") \
    | sort -u)
# Exclude things that are in the failed services
# grep -vFxf means:
# -v	Invert: keep lines that don’t match
# -F	Fixed strings: literal comparison, not regex
# -x	Whole line: match entire line only
# -f file	Read exclusion patterns from file

mapfile -t WARNING_SERVICES < <(printf '%s\n' "${ALL_WARN_SERVICES[@]}" \
    | grep -vFxf <(printf '%s\n' "${FAILED_SERVICES[@]}" "${ERROR_SERVICES[@]}") \
    | sort -u)

echo "Generating failed services log"
{
  echo "Failed Services Log - $(date +%Y-%m-%d)"
  echo "=================================================="
  
  for service in "${FAILED_SERVICES[@]}"; do
      [ -z "$service" ] && continue
      echo ""
      echo "[$service]"
      echo "--------------------------------------------------"
        
      journalctl -t "$service" -n 10 --no-pager -o cat 2>/dev/null \
        | grep -v "^-- No entries --\$" \
        || journalctl -u "$service" -n 10 --no-pager -o cat 2>/dev/null \
        || echo "No logs available"
  done
} > "$FAILED_LOG"

echo "Generating error services log"
{
  echo "Error Services Log - $(date +%Y-%m-%d)"
  echo "=================================================="
  
  for service in "${ERROR_SERVICES[@]}"; do
      [ -z "$service" ] && continue
      echo ""
      echo "[$service]"
      echo "--------------------------------------------------"
      journalctl -t "$service" --priority=err -n 10 --no-pager -o cat 2>/dev/null \
        | grep -v "^-- No entries --\$" \
        || journalctl -u "$service" --priority=err -n 10 --no-pager -o cat 2>/dev/null \
        || echo "No logs available"
  done
} > "$ERROR_LOG"

echo "Generating warning services log"
{
  echo "Warning Services Log - $(date +%Y-%m-%d)"
  echo "=================================================="
  
  for service in "${WARNING_SERVICES[@]}"; do
      [ -z "$service" ] && continue
      echo ""
      echo "[$service]"
      echo "--------------------------------------------------"
      journalctl -t "$service" --priority=warning -n 10 --no-pager -o cat 2>/dev/null \
        | grep -v "^-- No entries --\$" \
        || journalctl -u "$service" --priority=warning -n 10 --no-pager -o cat 2>/dev/null \
        || echo "No logs available"
  done
} > "$WARNING_LOG"


FAILED_LIST=$(IFS=', '; echo "${FAILED_SERVICES[*]}")
ERROR_LIST=$(IFS=', '; echo "${ERROR_SERVICES[*]}")
WARNING_LIST=$(IFS=', '; echo "${WARNING_SERVICES[*]}")

MESSAGE="**Failed**: ${FAILED_LIST:-none}

**Errors**: ${ERROR_LIST:-none}

**Warnings**: ${WARNING_LIST:-none}"

echo "$MESSAGE" | webhook-notifier home-server-updates - --title "Daily System Status" --notify -a "$FAILED_LOG" -a "$ERROR_LOG" -a "$WARNING_LOG"


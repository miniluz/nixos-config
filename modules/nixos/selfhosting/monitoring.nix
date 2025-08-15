{
  config,
  pkgs,
  host-secrets,
  ...
}:
let
  # Create the monitoring script
  monitorScript = pkgs.writeShellScriptBin "daily-system-monitor" ''
    #!/usr/bin/env bash

    # Configuration
    WEBHOOK_URL="$(cat ${config.age.secrets.monitoring-webhook.path})"
    HOSTNAME=$(cat /etc/hostname)
    DATE=$(date '+%Y-%m-%d')
    USER_ID="123456789012345678"    

    send_discord() {
        local title="$1"
        local description="$2"
        local color="$3"  # Decimal color code
        local ping="<@$USER_ID>"
        
        ${pkgs.jq}/bin/jq -n \
            --arg content "$ping" \
            --arg title "$title" \
            --arg description "$description" \
            --arg color "$color" \
            --arg timestamp "$(date -Iseconds)" \
            --arg hostname "$HOSTNAME" \
            '{
                content: $content,
                embeds: [{
                    title: $title,
                    description: $description,
                    color: ($color | tonumber),
                    timestamp: $timestamp,
                    footer: {
                        text: $hostname
                    }
                }]
            }' | ${pkgs.curl}/bin/curl -H "Content-Type: application/json" \
                -X POST \
                -d @- \
                "$WEBHOOK_URL"
    }

    # Check for critical errors in the last 24 hours
    echo "Checking system logs for errors..."

    ERRORS=$(${pkgs.systemd}/bin/journalctl --since "yesterday" --priority err --no-pager -q)
    WARNINGS=$(${pkgs.systemd}/bin/journalctl --since "yesterday" --priority warning --no-pager -q | head -20)

    # Check failed systemd services
    FAILED_SERVICES=$(${pkgs.systemd}/bin/systemctl --failed --no-legend --no-pager | ${pkgs.coreutils}/bin/wc -l)

    # Check disk usage
    DISK_USAGE=$(${pkgs.coreutils}/bin/df -h / | ${pkgs.coreutils}/bin/tail -1 | ${pkgs.gawk}/bin/awk '{print $5}' | ${pkgs.coreutils}/bin/tr -d '%')

    # Check memory usage
    MEMORY_USAGE=$(${pkgs.coreutils}/bin/free | ${pkgs.gawk}/bin/awk '/^Mem:/{printf "%.1f", $3/$2 * 100.0}')

    # Check load average
    LOAD_AVG=$(${pkgs.coreutils}/bin/uptime | ${pkgs.gawk}/bin/awk -F'load average:' '{print $2}')

    # Determine alert level and color
    COLOR=3447003  # Blue - normal
    ALERT_LEVEL="INFO"

    # Convert memory usage to integer for comparison
    MEMORY_USAGE_INT="''${MEMORY_USAGE%.*}"

    if [ ! -z "$ERRORS" ] || [ "$FAILED_SERVICES" -gt 0 ]; then
        COLOR=15548997  # Red - critical
        ALERT_LEVEL="CRITICAL"
    elif [ "$DISK_USAGE" -gt 90 ]; then
        COLOR=16769024  # Yellow - warning
        ALERT_LEVEL="WARNING"
    elif [ "$MEMORY_USAGE_INT" -gt 90 ]; then
        COLOR=16769024  # Yellow - warning
        ALERT_LEVEL="WARNING"
    fi

    # Build the report
    REPORT="**Daily System Report - $DATE**\n\n"
    REPORT+="**System Status:** $ALERT_LEVEL\n"
    REPORT+="**Uptime:** $(${pkgs.coreutils}/bin/uptime -p)\n"
    REPORT+="**Load Average:**$LOAD_AVG\n"
    REPORT+="**Memory Usage:** $MEMORY_USAGE%\n"
    REPORT+="**Disk Usage:** $DISK_USAGE%\n"
    REPORT+="**Failed Services:** $FAILED_SERVICES\n\n"

    if [ ! -z "$ERRORS" ]; then
        REPORT+="**🚨 Critical Errors Found:**\n\`\`\`\n"
        REPORT+="$(echo "$ERRORS" | head -10)\n"
        REPORT+="\`\`\`\n\n"
    fi

    if [ "$FAILED_SERVICES" -gt 0 ]; then
        REPORT+="**❌ Failed Services:**\n\`\`\`\n"
        REPORT+="$(${pkgs.systemd}/bin/systemctl --failed --no-legend --no-pager)\n"
        REPORT+="\`\`\`\n\n"
    fi

    if [ ! -z "$WARNINGS" ]; then
        REPORT+="**⚠️ Recent Warnings (last 20):**\n\`\`\`\n"
        REPORT+="$(echo "$WARNINGS" | head -10)\n"
        REPORT+="\`\`\`\n"
    fi

    # Send the report
    send_discord "$HOSTNAME - Daily System Report" "$REPORT" "$COLOR"

    echo "Daily monitoring report sent to Discord"
  '';

in
{
  config = {
    age.secrets.monitoring-webhook.file = "${host-secrets}/monitoring-webhook.age";

    # Create the systemd service
    systemd.services.daily-system-monitor = {
      description = "Daily System Monitor";
      serviceConfig = {
        Type = "oneshot";
        User = "root"; # Needed to read all journal entries
        ExecStart = "${monitorScript}/bin/daily-system-monitor";
      };
      # Optional: specify which services this depends on
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
    };

    # Create the timer to run daily at 9 AM
    systemd.timers.daily-system-monitor = {
      description = "Run Daily System Monitor";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        # OnCalendar = "daily";
        OnCalendar = "*-*-* 09:00:00"; # Uncomment for specific time
        Persistent = true; # Run if system was off during scheduled time
        RandomizedDelaySec = "30m"; # Add some randomization
      };
    };
  };
}

{
  config,
  lib,
  host-secrets,
  miniluz-pkgs,
  ...
}:
let
  cfg = config.miniluz.selfhosting;
in
{
  config = lib.mkIf (cfg.enable && cfg.server.enable) {
    age.secrets.monitoring-webhook.file = "${host-secrets}/monitoring-webhook.age"; # Create the systemd service

    services.netdata = {
      enable = true;
      # config = {
      #   global = {
      #     "bind to" = "*";
      #   };
      # };
    };

    systemd.services.daily-system-monitor = {
      description = "Daily System Monitor";
      serviceConfig = {
        Type = "oneshot";
        User = "root"; # Needed to read all journal entries
        ExecStart = lib.getExe miniluz-pkgs.daily-system-monitor;
        Environment = [
          "WEBHOOK_PATH=${config.age.secrets.monitoring-webhook.path}"
          "USER_ID=307616962156953601"
        ];
      };

      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
    };

    # Create the timer to run daily at 9 AM
    systemd.timers.daily-system-monitor = {
      description = "Run Daily System Monitor";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "*-*-* 09:00:00"; # Run daily at 9 AM
        Persistent = true;
        RandomizedDelaySec = "30m"; # Add some randomization
      };
    };
  };
}

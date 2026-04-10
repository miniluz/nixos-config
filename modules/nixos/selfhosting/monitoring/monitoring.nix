{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.miniluz.selfhosting;
  inherit (config.miniluz.constants) miniluz-pkgs host-secrets;
in
{
  config = lib.mkIf (cfg.enable && cfg.server.enable) {
    services.ttyd = {
      enable = true;
      writeable = false;
      entrypoint = [
        (lib.getExe miniluz-pkgs.btop-luzwrap)
      ];
      port = 7861;
      interface = "lo";
      clientOptions = {
        fontSize = "16";
        fontFamily = "FiraCode Nerd Font";
      };
    };

    age.secrets.monitoring-webhook.file = "${host-secrets}/monitoring-webhook.age";

    systemd.services.daily-system-monitor = {
      description = "Daily System Monitor";
      serviceConfig = {
        Type = "oneshot";
        User = "root"; # Needed to read all journal entries

        Environment = [
          "WEBHOOK_FILE=${config.age.secrets.monitoring-webhook.path}"
        ];

        ExecStart = lib.getExe (
          pkgs.writeShellApplication {
            name = "daily-system-monitor";
            text = lib.replaceString "#!/usr/bin/env bash" "" (builtins.readFile ./daily-system-monitor.sh);
            runtimeInputs = [
              miniluz-pkgs.webhook-notifier
              pkgs.jq
            ];
            bashOptions = [ ];
          }
        );
      };

      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
    };

    systemd.timers.daily-system-monitor = {
      description = "Run Daily System Monitor";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "*-*-* 09:00:00"; # Run daily at 9 AM
        Persistent = true;
        RandomizedDelaySec = "30m";
      };
    };

    systemd.services.zfs-scrub-notify = {
      description = "ZFS pools scrubbing";
      after = [ "zfs-import.target" ];
      serviceConfig = {
        Type = "simple";
        IOSchedulingClass = "idle";

        Environment = [
          "WEBHOOK_FILE=${config.age.secrets.monitoring-webhook.path}"
        ];

        ExecStart = lib.getExe (
          pkgs.writeShellApplication {
            name = "zfs-scrub";
            text = lib.replaceString "#!/usr/bin/env bash" "" (builtins.readFile ./zfs-scrub.sh);
            runtimeInputs = [
              miniluz-pkgs.webhook-notifier
              config.boot.zfs.package
            ];
            bashOptions = [ ];
          }
        );
      };
    };

    systemd.timers.zfs-scrub-notify = {
      wantedBy = [ "timers.target" ];
      after = [ "multi-user.target" ];
      timerConfig = {
        OnCalendar = "monthly";
        Persistent = "yes";
        RandomizedDelaySec = "6h";
      };
    };
  };
}

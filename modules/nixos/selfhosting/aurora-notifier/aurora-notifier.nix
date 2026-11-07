{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.miniluz.selfhosting;
in
{
  config = lib.mkIf (cfg.enable && cfg.server.enable) {
    systemd.services.aurora-notifier = {
      description = "Aurora notifier";
      serviceConfig = {
        Type = "oneshot";
        DynamicUser = "yes";

        Environment = [
          "WEBHOOK_FILE=${config.age.secrets.monitoring-webhook.path}"
        ];

        ExecStart = lib.getExe (
          pkgs.writers.writePython3Bin "aurora-notifier" {
            libraries = [ ];
          } (builtins.readFile ./aurora-notifier.py)
        );
      };

      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
    };

    systemd.timers.aurora-notifier = {
      description = "Run Aurora notifier";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "*-*-* 09:00:00"; # Run daily at 9 AM
        Persistent = true;
      };
    };
  };
}

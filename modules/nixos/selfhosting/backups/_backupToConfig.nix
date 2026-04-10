{
  config,
  lib,
  pkgs,
  miniluz-pkgs,
}:
name: backupConfig: {
  services.borgbackup.jobs.${name} = {
    inherit (backupConfig)
      paths
      readWritePaths
      preHook
      postHook
      ;

    extraArgs = "--verbose";
    extraInitArgs = "--remote-path=borg-1.4 --make-parent-dirs";
    extraCreateArgs = "--list --stats --checkpoint-interval 600";

    encryption.mode = "repokey-blake2";
    encryption.passCommand = "cat ${config.age.secrets.borg-pass.path}";

    environment.BORG_RSH = "ssh -i ${config.age.secrets.borg-ssh-ed25519.path}";
    repo = "ssh://u489829-sub1@u489829-sub1.your-storagebox.de:23/./home-server-backups/${name}";

    # repo = "/media/backups";
    compression = "auto,zstd";
    startAt = "daily";

    prune.keep = {
      within = "3d"; # Keep all archives from the last day
      daily = 7;
      weekly = 4;
      monthly = -1; # Keep at least one archive for each month
    };
  };

  systemd.services."borgbackup-job-${name}" = {

    serviceConfig = {
      CPUSchedulingPolicy = lib.mkForce "batch";
      Nice = lib.mkForce 10;
      IOSchedulingClass = lib.mkForce "2";
      IOSchedulingPriority = lib.mkForce "3";
    };

    preStart = lib.mkBefore ''
      connected=false
      for i in {1..10}; do
          if ${lib.getExe pkgs.curl} -s --connect-timeout 3 --max-time 5 http://1.1.1.1 >/dev/null 2>&1; then
              echo "Connection established"
              connected=true
              break
          fi
          echo "Attempt $i failed, retrying..."
          sleep 2
      done

      if [ "$connected" = false ]; then
          echo "Failed to connect after 10 attempts"
          exit 1
      fi
    '';
  };

  systemd.services."borg-check-${name}" = {
    description = "Borg repo check for ${name}";

    serviceConfig = {
      Type = "simple";
      IOSchedulingClass = "idle";

      Environment = [
        "SCAN_TITLE=actual"
        "BORG_REPO=ssh://u489829-sub1@u489829-sub1.your-storagebox.de:23/./home-server-backups/actual"
        "BORG_RSH=ssh -i ${config.age.secrets.borg-ssh-ed25519.path}"
        "BORG_PASSCOMMAND=cat ${config.age.secrets.borg-pass.path}"
        "WEBHOOK_FILE=${config.age.secrets.monitoring-webhook.path}"
      ];

      ExecStart = lib.getExe (
        pkgs.writeShellApplication {
          name = "borg-check-${name}";
          text = lib.replaceString "#!/usr/bin/env bash" "" (builtins.readFile ./borg-check.sh);
          runtimeInputs = [
            miniluz-pkgs.webhook-notifier
            config.services.borgbackup.package
          ];
          bashOptions = [ ];
        }
      );
    };
  };

  systemd.timers."borg-check-${name}" = {
    wantedBy = [ "timers.target" ];
    after = [ "multi-user.target" ];
    timerConfig = {
      OnCalendar = "quarterly";
      Persistent = "yes";
      RandomizedDelaySec = "6h";
    };
  };
}

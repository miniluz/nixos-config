{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkOption mkEnableOption types;
  cfg = config.miniluz.selfhosting;

  backupOpts = {
    options = {
      enable = mkOption { default = true; };
      paths = mkOption { type = with types; listOf str; };
      readWritePaths = mkOption {
        type = with types; listOf path;
        default = [ ];
      };
      preHook = mkOption {
        type = with types; lines;
        default = "";
      };
      postHook = mkOption {
        type = with types; lines;
        default = "";
      };
    };
  };

  backupToConfig = name: backupConfig: {
    services.borgbackup.jobs.${name} = {
      inherit (backupConfig)
        paths
        readWritePaths
        preHook
        postHook
        ;
      extraCreateArgs = "--verbose --list --stats --checkpoint-interval 600";
      encryption.mode = "none";
      # encryption.mode = "repokey-blake2"
      # encryption.passCommand = "cat /run/secrets/borg-passphrase";
      # environment.BORG_RSH = "ssh -i /home/danbst/.ssh/id_ed25519";
      # repo = "ssh://user@example.com:23/nebula-backups/${name}";
      repo = "/media/backups";
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

      unitConfig.OnFailure = "notify-backup-failure.service";

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
  };

  backupsToConfig = lib.flip lib.pipe [
    (lib.filterAttrs (_: v: v.enable == true))
    (lib.mapAttrsToList backupToConfig)
    (lib.fold lib.recursiveUpdate { })
  ];

in
{
  options.miniluz.selfhosting.backups = {
    enable = mkEnableOption "Backups";
    backups = mkOption {
      default = { };
      type = with types; attrsOf (submodule backupOpts);
    };
  };

  config =
    let
      mappedBackupConfig = (backupsToConfig cfg.backups.backups);
    in
    lib.mkIf (cfg.enable && cfg.backups.enable && cfg.server.enable) (
      lib.mkMerge [
        {
          systemd.services."notify-backup-failure" = {
            enable = true;
            script = ''
              # I don't know yet...
            '';
          };
        }
        {
          inherit (mappedBackupConfig) services systemd;
        }
      ]
    );

}

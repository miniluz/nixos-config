{
  pkgs,
  lib,
  config,
  host-secrets,
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
  };

  backupsToConfig = lib.flip lib.pipe [
    (lib.filterAttrs (_: v: v.enable))
    (lib.mapAttrsToList backupToConfig)
    (lib.foldr lib.recursiveUpdate {
      services = { };
      systemd = { };
    })
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
      mappedBackupConfig = backupsToConfig cfg.backups.backups;
      secrets = config.age.secrets;
      backup-borg = pkgs.runCommand "backup-borg" { buildInputs = [ pkgs.makeWrapper ]; } ''
        makeWrapper ${pkgs.borgbackup}/bin/borg $out/bin/backup-borg \
          --set BORG_RSH "ssh -i ${secrets.borg-ssh-ed25519.path}" \
          --set BORG_PASSCOMMAND "cat ${secrets.borg-pass.path}" \
          --set BORG_REMOTE_PATH "borg-1.4"
      '';
    in
    lib.mkIf (cfg.enable && cfg.backups.enable && cfg.server.enable) (
      lib.mkMerge [
        {
          age.secrets.borg-ssh-ed25519.file = "${host-secrets}/borg-ssh-ed25519.age";
          age.secrets.borg-pass.file = "${host-secrets}/borg-pass.age";
        }
        {
          inherit (mappedBackupConfig) services systemd;
        }
        {
          environment.systemPackages = [ backup-borg ];
        }
      ]
    );

}

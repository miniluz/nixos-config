{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkOption mkEnableOption types;
  cfg = config.miniluz.selfhosting;

  inherit (config.miniluz.constants) host-secrets miniluz-pkgs;

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

  backupToConfig = import ./_backupToConfig.nix {
    inherit
      config
      lib
      pkgs
      miniluz-pkgs
      ;
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
          programs.ssh.knownHosts."[u489829-sub1.your-storagebox.de]:23".publicKeyFile =
            "${host-secrets}/hetzner-public-keys.pub";

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

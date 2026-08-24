{
  pkgs,
  config,
  lib,
  ...
}:
{
  options.miniluz.selfhosting.fileserver = lib.mkOption {
    default = true;
    description = "Enable Samba";
  };

  config =
    let
      cfg = config.miniluz.selfhosting;
      serverStorage = config.miniluz.selfhosting.server.serverStorage;
      dataDir = "${serverStorage}/samba";
      notBackedUpFolder = "${dataDir}/public";
      backedUpFolder = "${dataDir}/backed-up";

      fileserverService =
        {
          name,
          folder,
          port,
        }:
        {
          description = "Copyparty server - ${name}";

          after = [ "network-online.target" ];
          wants = [ "network-online.target" ];
          wantedBy = [ "multi-user.target" ];

          serviceConfig = {
            ExecStart = "${pkgs.copyparty}/bin/copyparty --name ${lib.escapeShellArg name} -v ${lib.escapeShellArg "${folder}:/:rwmd."} -i 127.0.0.1 -p ${toString port}";

            Restart = "on-failure";
            RestartSec = "5s";

            User = "fileserver";
            Group = "fileserver";

            NoNewPrivileges = true;
            PrivateTmp = true;

            ProtectSystem = "strict";
            ReadWritePaths = [
              folder
            ];
          };

        };
    in
    lib.mkIf (cfg.enable && cfg.fileserver) (
      lib.mkMerge [
        (lib.mkIf cfg.server.enable {
          users.users.fileserver = {
            isSystemUser = true;
            group = "fileserver";
            home = "${dataDir}";
            createHome = false;
          };
          users.groups.fileserver = { };

          systemd = {
            services.not-backed-up = fileserverService {
              name = "not-backed-up";
              folder = notBackedUpFolder;
              port = "3924";
            };
            services.backed-up = fileserverService {
              name = "backed-up";
              folder = backedUpFolder;
              port = "3925";
            };

            tmpfiles.rules = [
              "d ${dataDir} 0750 fileserver fileserver"
              "d ${notBackedUpFolder} 0750 fileserver fileserver"
              "d ${backedUpFolder} 0750 fileserver fileserver"
            ];
          };

          miniluz.selfhosting.backups.backups.fileserver-backed-up.paths = [ backedUpFolder ];

        })
        (lib.mkIf (!cfg.server.enable) {
          environment.systemPackages = [ pkgs.davfs2 ];

          fileSystems."/mnt/fileserver-not-backed-up" = {
            device = "https://not-backed-up.home.miniluz.dev";
            fsType = "davfs";
            options = [
              "uid=${toString config.users.users.miniluz.uid}"
              "gid=${toString config.users.groups.users.gid}"
              "file_mode=0700"
              "dir_mode=0700"

              "nofail"
              "x-systemd.automount"
              "x-systemd.idle-timeout=60"
              "x-systemd.device-timeout=5s"
              "x-systemd.mount-timeout=5s"
            ];
          };

          fileSystems."/mnt/fileserver-backed-up" = {
            device = "https://backed-up.home.miniluz.dev";
            fsType = "davfs";
            options = [
              "uid=${toString config.users.users.miniluz.uid}"
              "gid=${toString config.users.groups.users.gid}"
              "file_mode=0700"
              "dir_mode=0700"

              "nofail"
              "x-systemd.automount"
              "x-systemd.idle-timeout=60"
              "x-systemd.device-timeout=5s"
              "x-systemd.mount-timeout=5s"
            ];
          };

        })
      ]
    );
}

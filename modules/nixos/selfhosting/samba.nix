{
  pkgs,
  config,
  lib,
  ...
}:
{
  options.miniluz.selfhosting.samba = lib.mkOption {
    default = true;
    description = "Enable Samba";
  };

  config =
    let
      cfg = config.miniluz.selfhosting;
      serverStorage = config.miniluz.selfhosting.server.serverStorage;
      dataDir = "${serverStorage}/samba";
      publicFolder = "${dataDir}/public";
    in
    lib.mkIf (cfg.enable && cfg.samba) (
      lib.mkMerge [
        (lib.mkIf cfg.server.enable {
          services = {
            samba = {
              enable = true;
              nmbd.enable = false;
              winbindd.enable = false;

              settings = {
                global = {
                  "workgroup" = "WORKGROUP";
                  "server string" = "smbnix";
                  "netbios name" = "smbnix";
                  "security" = "user";
                  #"use sendfile" = "yes";
                  #"max protocol" = "smb2";
                  # note: localhost is the ipv6 localhost ::1
                  "interfaces" = "100.64.1.1/0";
                  # "interfaces" = "lo tailscale0";
                  "bind interfaces only" = "yes";
                  "guest account" = "nobody";
                  "map to guest" = "bad user";

                  "load printers" = "no";
                  "disable spoolss" = "yes";
                };
                public = {
                  path = publicFolder;
                  browseable = "yes";
                  "read only" = "no";
                  "guest ok" = "yes";
                  "create mask" = "0644";
                  "directory mask" = "0755";
                  "force user" = "samba";
                  "force group" = "samba";
                };
              };
            };

            samba-wsdd = {
              enable = true;
              interface = "tailscale0";
            };

            avahi = {
              publish.enable = true;
              publish.userServices = true;
              # ^^ Needed to allow samba to automatically register mDNS records (without the need for an `extraServiceFile`
              nssmdns4 = true;
              # ^^ Not one hundred percent sure if this is needed- if it aint broke, don't fix it
              allowInterfaces = [ "tailscale0" ];
              enable = true;
            };
          };

          users.users.samba = {
            isSystemUser = true;
            group = "samba";
            home = "${dataDir}";
            createHome = false;
          };
          users.groups.samba = { };

          systemd = {
            targets.samba.after = [ "tailsaled.service" ];
            services.samba-smbd.after = [ "tailsaled.service" ];
            services.samba-wsdd.after = [ "tailsaled.service" ];

            tmpfiles.rules = [
              "d ${dataDir} 0750 samba samba"
              "d ${publicFolder} 0750 samba samba"
            ];
          };

          networking.firewall = {
            interfaces."tailscale0" = {
              allowedTCPPorts = [
                139 # samba
                445 # samba
                5357 # samba-wsdd
              ];
              allowedUDPPorts = [
                137 # samba
                138 # samba
                3702 # samba-wsdd
                5353 # avahi
              ];
            };
          };
        })
        (lib.mkIf (!cfg.server.enable) {
          environment.systemPackages = [ pkgs.cifs-utils ];

          fileSystems."/mnt/samba-public" = {
            device = "//home-server/public";
            fsType = "cifs";
            options =
              let
                automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
              in
              [
                "${automount_opts},guest,uid=${config.users.users.miniluz.uid},gid=${config.users.groups.users.gid},file_mode=0700,dir_mode=0700"
              ];
          };
        })
      ]
    );
}

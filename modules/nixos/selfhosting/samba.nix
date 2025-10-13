{
  config,
  lib,
  ...
}:
{
  options.miniluz.selfhosting.samba = lib.mkEnableOption "Samba";

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
              securityType = "user";

              settings = {
                global = {
                  "workgroup" = "WORKGROUP";
                  "server string" = "smbnix";
                  "netbios name" = "smbnix";
                  "security" = "user";
                  #"use sendfile" = "yes";
                  #"max protocol" = "smb2";
                  # note: localhost is the ipv6 localhost ::1
                  "interfaces" = "tailscale0";
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

            samba-wsdd.enable = true;
            avahi = {
              publish.enable = true;
              publish.userServices = true;
              # ^^ Needed to allow samba to automatically register mDNS records (without the need for an `extraServiceFile`
              nssmdns4 = true;
              # ^^ Not one hundred percent sure if this is needed- if it aint broke, don't fix it
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

          systemd.tmpfiles.rules = [
            "d ${dataDir} 0750 samba samba"
            "d ${publicFolder} 0750 samba samba"
          ];

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
      ]
    );
}

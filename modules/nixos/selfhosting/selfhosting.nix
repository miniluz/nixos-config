{
  config,
  lib,
  miniluz-pkgs,
  pkgs,
  ...
}:
let
  cfg = config.miniluz.selfhosting;
in
{
  options.miniluz.selfhosting.enable = lib.mkEnableOption "Selfhosting";
  options.miniluz.selfhosting.server = {
    enable = lib.mkOption {
      default = false;
      description = "This computer is a server";
    };
    address = lib.mkOption { default = "100.64.1.1"; };
    serverStorage = lib.mkOption {
      default = "/media/server-storage";
      description = "Path where the server's application's data should be stored";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      services.tailscale.enable = true;

      # TODO: remove this when it's fixed
      nixpkgs.overlays = [
        (_: prev: {
          tailscale = prev.tailscale.overrideAttrs (old: {
            checkFlags = builtins.map (
              flag:
              if prev.lib.hasPrefix "-skip=" flag then
                flag + "|^TestGetList$|^TestIgnoreLocallyBoundPorts$|^TestPoller$"
              else
                flag
            ) old.checkFlags;
          });
        })
      ];
    })
    (lib.mkIf (cfg.enable && cfg.server.enable) (
      let
        pgDataDir = "${cfg.server.serverStorage}/postgres/${config.services.postgresql.package.psqlSchema}";
      in
      {
        environment.arbys.enable = true;

        # Keep postgres within hdd
        users.users.postgres.createHome = true;
        services.postgresql = {
          package = pkgs.postgresql_16;
          dataDir = pgDataDir;
        };

        # ZFS stuff
        services.zfs = {
          autoSnapshot = {
            enable = true;
            flags = "-k -p --utc";
          };
          autoScrub.enable = true;
        };

        # Ensure podman runs properly
        systemd.tmpfiles.rules = [
          "R! /tmp/storage-run-*"
          "d ${pgDataDir} 700 postgres postgres"
        ];

        virtualisation = {
          podman = {
            enable = true;
            autoPrune.enable = true;
            dockerCompat = true;
            defaultNetwork.settings.dns_enabled = true;
          };

          oci-containers.backend = "podman";

          quadlet = {
            enable = true;
            autoUpdate.enable = true;
          };
        };

        # Enable container name DNS for non-default Podman networks.
        # https://github.com/NixOS/nixpkgs/issues/226365
        networking.firewall.interfaces."podman+".allowedUDPPorts = [ 53 ];

        environment.systemPackages = with miniluz-pkgs; [
          luznix-rebuild-server
        ];
      }
    ))
  ];
}

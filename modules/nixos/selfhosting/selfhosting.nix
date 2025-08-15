{
  config,
  lib,
  miniluz-pkgs,
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
    })
    (lib.mkIf (cfg.enable && cfg.server.enable) {
      environment.arbys.enable = true;

      # Keep postgres within hdd
      users.users.postgres.createHome = true;
      services.postgresql.dataDir = "${cfg.server.serverStorage}/postgres/${config.services.postgresql.package.psqlSchema}";

      # Ensure podman runs properly
      systemd.tmpfiles.rules = [ "R! /tmp/storage-run-*" ];

      virtualisation = {
        podman = {
          enable = true;
          autoPrune.enable = true;
          dockerCompat = true;
          defaultNetwork.settings.dns_enabled = true;
        };

        oci-containers.backend = "podman";

        quadlet.enable = true;
      };

      # Enable container name DNS for non-default Podman networks.
      # https://github.com/NixOS/nixpkgs/issues/226365
      networking.firewall.interfaces."podman+".allowedUDPPorts = [ 53 ];

      environment.systemPackages = with miniluz-pkgs; [
        luznix-rebuild-server
      ];
    })
  ];
}

{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.miniluz.development.podman;
in
{
  config = lib.mkIf cfg {
    # https://wiki.nixos.org/wiki/Podman
    environment.systemPackages = [
      pkgs.podman-compose
    ];

    virtualisation.containers.enable = true;
    virtualisation = {
      podman = {
        enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
      };
    };

    users.users.miniluz = {
      isNormalUser = true;
      extraGroups = [ "podman" ];
    };
  };
}

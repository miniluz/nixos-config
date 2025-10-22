{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.miniluz.development.containers;
in
{
  config = lib.mkIf cfg {
    # https://wiki.nixos.org/wiki/Docker
    environment.systemPackages = [
      pkgs.podman-compose
    ];

    virtualisation.docker = {
      enable = true;
      # daemon.settings = {
      #   "default-ulimits".
      # };
    };

    users.users.miniluz.extraGroups = [ "docker" ];

    # environment.etc."containers/registries.conf".text = lib.mkForce ''
    #   [registries.search]
    #   registries = ['docker.io']
    # '';

  };
}

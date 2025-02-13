{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.miniluz.podman;
in
{
  options.miniluz.podman = {
    enable = lib.mkEnableOption "Enable Podman.";
    user = lib.mkOption {
      default = "miniluz";
    };
  };

  config = lib.mkIf cfg.enable {
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

    users.users."${cfg.user}" = {
      isNormalUser = true;
      extraGroups = [ "podman" ];
    };
  };
}

{ config, pkgs, lib, ... }:
let
  cfg = config.miniluz.podman;
in
{
  options.miniluz.podman.enable = lib.mkEnableOption "Enable Podman.";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.podman-compose
    ];

    virtualisation.podman.enable = true;
    virtualisation.podman.dockerCompat = true;
  };
}

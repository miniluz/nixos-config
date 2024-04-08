{ config, pkgs, lib, ... }:
let
  cfg = config.miniluz.podman;
in
{
  options.miniluz.podman.enable = lib.mkEnableOption "Enable Podman.";

  config = lib.mkIf cfg.enable {
    virtualisation.podman.enable = true;
    virtualisation.podman.dockerCompat = true;
  };
}

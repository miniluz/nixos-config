{ config, pkgs, lib, ... }:
let
  cfg = config.miniluz.gnome;
in
{
  options.miniluz.gnome.enable = lib.mkEnableOption "Enable GNOME config.";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.gnome.gnome-tweaks
    ];
  };
}

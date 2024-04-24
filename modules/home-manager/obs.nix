{ config, lib, pkgs, ... }:
let
  cfg = config.miniluz.obs-studio;
in
{
  options.miniluz.obs-studio.enable = lib.mkEnableOption "Enable configured git.";

  config = lib.mkIf cfg.enable {
    programs.obs-studio = {
      enable = true;
      plugins = with pkgs; [
        obs-studio-plugins.obs-vkcapture
        obs-studio-plugins.obs-mute-filter
      ];
    };
  };
}
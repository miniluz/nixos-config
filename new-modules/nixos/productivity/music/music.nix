{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.miniluz.music;
in
{
  options.miniluz.music.enable = lib.mkEnableOption "Enable all of my music production configuration.";

  config.hm = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      reaper
      reaper-reapack-extension

      helm

      yabridge
      wineWowPackages.yabridge
      yabridgectl
      winetricks
    ];

    home.sessionVariables."W_NO_WIN64_WARNINGS" = "1";
  };
}

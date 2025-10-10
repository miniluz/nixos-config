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

  config = lib.mkIf cfg.enable {
    users.users.miniluz.packages = with pkgs; [
      reaper
      reaper-reapack-extension

      helm

      yabridge
      wineWowPackages.yabridge
      yabridgectl
      winetricks
    ];

    environment.sessionVariables."W_NO_WIN64_WARNINGS" = "1";
  };
}

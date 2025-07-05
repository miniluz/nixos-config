{
  config,
  pkgs,
  lib,
  paths,
  ...
}:
let
  cfg = config.miniluz.yabridge;
in
{
  options.miniluz.yabridge.enable = lib.mkEnableOption "Enable yabridge.";

  config = lib.mkIf cfg.enable {

    home.packages = with pkgs; [
      wineWowPackages.yabridge
      yabridgectl
      winetricks
    ];

    home.sessionVariables."W_NO_WIN64_WARNINGS" = "1";
  };
}

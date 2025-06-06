{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.miniluz.yabridge;
in
{
  options.miniluz.yabridge.enable = lib.mkEnableOption "Enable yabridge.";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      bottles
      yabridge
      yabridgectl
    ];
  };
}

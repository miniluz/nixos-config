{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.miniluz.reaper;
in
{
  options.miniluz.reaper.enable = lib.mkEnableOption "Enable Reaper.";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.reaper
    ];
  };
}

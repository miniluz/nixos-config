{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  cfg = config.miniluz.playit;
in
{
  options.miniluz.gaming.enable = lib.mkEnableOption "Enable PlayIt.";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      playit
    ];
  };
}

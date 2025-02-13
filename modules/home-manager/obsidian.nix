{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.miniluz.obsidian;
in
{
  options.miniluz.obsidian.enable = lib.mkEnableOption "Enable Obsidian.";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.obsidian
    ];
  };
}

{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.miniluz.work;
in
{
  options.miniluz.work.enable = lib.mkEnableOption "Enable Blender.";

  config.hm = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      slack
    ];
  };
}

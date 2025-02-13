{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.miniluz.blender;
in
{
  options.miniluz.blender.enable = lib.mkEnableOption "Enable Blender.";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.blender-hip
      pkgs.ffmpeg_7
    ];
  };
}

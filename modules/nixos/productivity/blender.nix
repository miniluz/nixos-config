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
    users.users.miniluz.packages = with pkgs; [
      blender-hip
      ffmpeg_7
    ];
  };
}

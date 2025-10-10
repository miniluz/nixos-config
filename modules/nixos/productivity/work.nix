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

  config = lib.mkIf cfg.enable {
    users.users.miniluz.packages = with pkgs; [
      slack
    ];
  };
}

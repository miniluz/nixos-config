{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.miniluz.unity.enable;
in
{
  options.miniluz.unity.enable = lib.mkEnableOption "Unity";
  config = lib.mkIf cfg {
    users.users.miniluz.packages = with pkgs; [
      unityhub
    ];
  };
}

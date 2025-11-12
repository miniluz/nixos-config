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
  options.miniluz.work.enable = lib.mkEnableOption "Enable work.";

  config = lib.mkIf cfg.enable {
    users.users.miniluz.packages = with pkgs; [
      slack
    ];
  };
}

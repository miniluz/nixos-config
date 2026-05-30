{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.miniluz.gaming.ps4;
in
{
  options.miniluz.gaming.ps4 = lib.mkEnableOption "Enable PS4 emulation.";

  config = lib.mkIf cfg {
    users.users.miniluz.packages = with pkgs; [
      shadps4
    ];
  };
}

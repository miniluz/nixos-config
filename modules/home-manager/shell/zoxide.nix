{ config, pkgs, lib, ... }:
let
  cfg = config.miniluz.zoxide;
in
{
  options.miniluz.zoxide.enable = lib.mkEnableOption "Enable ZOxide.";

  config = lib.mkIf cfg.enable {
    programs.zoxide.enable = true;
  };
}

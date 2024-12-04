{ config, pkgs, lib, ... }:
let
  cfg = config.miniluz.firacode;
in
{
  options.miniluz.firacode.enable = lib.mkEnableOption "Enable FiraCode.";

  config = lib.mkIf cfg.enable {
    fonts.fontconfig.enable = true;
    home.packages = [
      pkgs.nerd-fonts.fira-code
    ];
  };
}

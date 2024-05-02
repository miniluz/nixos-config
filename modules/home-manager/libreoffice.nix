{ config, pkgs, lib, ... }:
let
  cfg = config.miniluz.libreoffice;
in
{
  options.miniluz.libreoffice.enable = lib.mkEnableOption "Enable LibreOffice.";

  config = lib.mkIf cfg.enable {
    fonts.fontconfig.enable = true;

    home.packages = [
      pkgs.cabin
      pkgs.libreoffice-qt
    ];
  };
}

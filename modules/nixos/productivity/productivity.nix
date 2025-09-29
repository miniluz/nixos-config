{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.miniluz.visual;
in
{
  config.hm = lib.mkIf cfg {
    fonts.fontconfig.enable = true;

    home.packages = with pkgs; [
      porsmo
      cabin
      libreoffice-qt

      obsidian
      zotero
    ];
  };
}

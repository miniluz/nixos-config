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
  config = lib.mkIf cfg {
    fonts.fontconfig.enable = true;

    users.users.miniluz.packages = with pkgs; [
      pandoc
      typst
      texliveBasic
      cabin
      libreoffice-qt

      obsidian
      zotero

      claude-code
    ];
  };
}

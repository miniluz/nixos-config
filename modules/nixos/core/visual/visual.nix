{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config.miniluz.constants) miniluz-pkgs;
in
{
  config = lib.mkIf config.miniluz.visual {
    users.users.miniluz.packages = with miniluz-pkgs; [
      ghostty-luzwrap
    ];

    environment.systemPackages = with pkgs; [
      vlc
      wl-clipboard
      nerd-fonts.fira-code
    ];
  };
}

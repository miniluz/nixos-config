{
  config,
  pkgs,
  miniluz-pkgs,
  lib,
  ...
}:
{
  config = lib.mkIf config.miniluz.visual {
    users.users.miniluz.packages = with miniluz-pkgs; [ kitty-luzwrap ];

    environment.systemPackages = with pkgs; [
      vlc
      nerd-fonts.fira-code
    ];
  };
}

{
  pkgs,
  ...
}:
{
  fonts.fontconfig.enable = true;
  home.packages = [
    pkgs.nerd-fonts.fira-code
  ];
}

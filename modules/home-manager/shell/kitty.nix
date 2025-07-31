{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config;
  catppuccin-kitty = pkgs.fetchFromGitHub {
    name = "kitty";
    owner = "catppuccin";
    repo = "kitty";
    rev = "d7d61716a83cd135344cbb353af9d197c5d7cec1";
    hash = "sha256-mRFa+40fuJCUrR1o4zMi7AlgjRtFmii4fNsQyD8hIjM=";
  };
in
{
  config = lib.mkIf (cfg.miniluz.shell.enable && cfg.miniluz.visual) {
    programs.kitty.enable = true;
    programs.kitty.extraConfig = ''
      include ./theme.conf
      font_family FiraCode Nerd Font
      background_opacity 0.95
      map ctrl+shift+f next_window
      map ctrl+shift+b previous_window
    '';

    home.sessionVariables.TERMINAL = "kitty";

    xdg.configFile."kitty/theme.conf".source = lib.mkForce "${catppuccin-kitty}/themes/mocha.conf";
  };
}

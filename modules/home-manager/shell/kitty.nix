{ pkgs, lib, config, ... }:
let
  cfg = config.miniluz.kitty;
  catpuccin-kitty = pkgs.fetchFromGitHub {
    name = "kitty";
    owner = "catppuccin";
    repo = "kitty";
    rev = "d7d61716a83cd135344cbb353af9d197c5d7cec1";
    hash = "sha256-mRFa+40fuJCUrR1o4zMi7AlgjRtFmii4fNsQyD8hIjM=";
  };
in
{
  options.miniluz.kitty.enable = lib.mkEnableOption "Enable Kitty.";
  options.miniluz.kitty.theme = lib.mkOption {
    type = lib.types.enum [ "frappe" "latte" "macchiato" "mocha" ];
    default = "mocha";
    example = "frappe";
    description = "Which of the Catppuccin themes to use";
  };

  config = lib.mkIf cfg.enable {
    programs.kitty.enable = true;
    programs.kitty.extraConfig = ''
      include ./theme.conf
      font_family FiraCode Nerd Font
      background_opacity 0.95
      map ctrl+shift+f next_window
      map ctrl+shift+b previous_window
    '';

    xdg.configFile."kitty/theme.conf".source = lib.mkForce "${catpuccin-kitty}/themes/${cfg.theme}.conf";
  };
}

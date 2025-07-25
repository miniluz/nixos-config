# shamelessly stolen from
# https://github.com/NixOS/nixpkgs/blob/0ef7eac2171048c8a4853a195cc1f9123b4906d6/pkgs/data/themes/catppuccin/default.nix
{
  pkgs,
  lib,
  config,
  ...
}:
let
  catpuccin-gitui = pkgs.fetchFromGitHub {
    name = "gitui";
    owner = "catppuccin";
    repo = "gitui";
    rev = "c7661f043cb6773a1fc96c336738c6399de3e617";
    hash = "sha256-CRxpEDShQcCEYtSXwLV5zFB8u0HVcudNcMruPyrnSEk=";
  };
  cfg = config.miniluz.gitui;
in
{
  options.miniluz.gitui = {
    enable = lib.mkEnableOption "Enable miniluz's gitui.";
    theme = lib.mkOption {
      type = lib.types.enum [
        "frappe"
        "latte"
        "macchiato"
        "mocha"
      ];
      default = "mocha";
      example = "frappe";
      description = "Which of the Catppuccin themes to use";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.gitui = {
      enable = true;
      theme = lib.readFile "${catpuccin-gitui}/themes/catppuccin-${cfg.theme}.ron";
      keyConfig = ''
        move_left: Some(( code: Char('h'), modifiers: "")),
        move_right: Some(( code: Char('l'), modifiers: "")),
        move_up: Some(( code: Char('k'), modifiers: "")),
        move_down: Some(( code: Char('j'), modifiers: "")),

        stash_open: Some(( code: Char('l'), modifiers: "")),
        open_help: Some(( code: F(1), modifiers: "")),
      '';
    };
  };
}

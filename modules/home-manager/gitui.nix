# shamelessly stolen from
# https://github.com/NixOS/nixpkgs/blob/0ef7eac2171048c8a4853a195cc1f9123b4906d6/pkgs/data/themes/catppuccin/default.nix
{ pkgs, lib, config, ... }:
let
  catpuccin-gitui = pkgs.fetchFromGitHub {
    name = "gitui";
    owner = "catppuccin";
    repo = "gitui";
    rev = "39978362b2c88b636cacd55b65d2f05c45a47eb9";
    hash = "sha256-kWaHQ1+uoasT8zXxOxkur+QgZu1wLsOOrP/TL+6cfII=";
  };
  cfg = config.miniluz.gitui;
in
{
  options.miniluz.gitui = {
    enable = lib.mkEnableOption "Enable miniluz's gitui.";
    theme = lib.mkOption {
      type = lib.types.enum [ "frappe" "latte" "macchiato" "mocha" ];
      default = "mocha";
      example = "frappe";
      description = "Which of the Catppuccin themes to use";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.gitui.enable = true;

    xdg.configFile."gitui/theme.ron".source = lib.mkForce "${catpuccin-gitui}/theme/${cfg.theme}.ron";
  };
}

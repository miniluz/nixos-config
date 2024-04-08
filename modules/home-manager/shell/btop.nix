{ pkgs, lib, config, ... }:
let
  catpuccin-btop = pkgs.fetchFromGitHub {
    name = "btop";
    owner = "catppuccin";
    repo = "btop";
    rev = "c6469190f2ecf25f017d6120bf4e050e6b1d17af";
    hash = "sha256-jodJl4f2T9ViNqsY9fk8IV62CrpC5hy7WK3aRpu70Cs=";
  };
  cfg = config.miniluz.btop;
in
{
  options.miniluz.btop = {
    enable = lib.mkEnableOption "Enable miniluz's btop.";
    theme = lib.mkOption {
      type = lib.types.enum [ "frappe" "latte" "macchiato" "mocha" ];
      default = "mocha";
      example = "frappe";
      description = "Which of the Catppuccin themes to use";
    };
  };

  config =
    let
      theme = "catppuccin_${cfg.theme}";
    in
    lib.mkIf cfg.enable {
      programs.btop.enable = true;
      programs.btop.settings.color_theme = theme;

      xdg.configFile."btop/theme/${theme}.theme".source = lib.mkForce "${catpuccin-btop}/theme/${theme}.theme";
    };
}

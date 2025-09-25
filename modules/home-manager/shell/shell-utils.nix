{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.miniluz.shell;
  catppuccin-btop = pkgs.fetchFromGitHub {
    name = "btop";
    owner = "catppuccin";
    repo = "btop";
    rev = "c6469190f2ecf25f017d6120bf4e050e6b1d17af";
    hash = "sha256-jodJl4f2T9ViNqsY9fk8IV62CrpC5hy7WK3aRpu70Cs=";
  };
  catppuccin-gitui = pkgs.fetchFromGitHub {
    name = "gitui";
    owner = "catppuccin";
    repo = "gitui";
    rev = "df2f59f847e047ff119a105afff49238311b2d36";
    hash = "sha256-DRK/j3899qJW4qP1HKzgEtefz/tTJtwPkKtoIzuoTj0=";
  };
  theme = "catppuccin_mocha";
in
{
  config = lib.mkIf cfg.enable {
    programs = {
      bat.enable = true;
      eza.enable = true;
      fd.enable = true;
      zoxide.enable = true;

      btop = {
        enable = true;
        settings.color_theme = theme;
      };
      # yazi file manager

      zellij = {
        enable = lib.mkDefault true;
        enableFishIntegration = lib.mkDefault true;
        settings = {
          on_force_close = "quit";
          show_startup_tips = false;
        };
      };

      gitui = {
        enable = true;
        # theme = lib.readFile "${catppuccin-gitui}/themes/${theme}.ron";
        keyConfig = ''
          move_left: Some(( code: Char('h'), modifiers: "")),
          move_right: Some(( code: Char('l'), modifiers: "")),
          move_up: Some(( code: Char('k'), modifiers: "")),
          move_down: Some(( code: Char('j'), modifiers: "")),

          stash_open: Some(( code: Char('l'), modifiers: "")),
          open_help: Some(( code: F(1), modifiers: "")),
        '';
      };

      fish.shellAliases = {
        cd = "z";
        exal = "eza --long --header --icons --git";
      };
    };

    xdg.configFile."btop/theme/${theme}.theme".source =
      lib.mkForce "${catppuccin-btop}/theme/${theme}.theme";

    services.tldr-update.enable = true;

    home.packages = with pkgs; [
      tldr
      dust
      ripgrep
      ripgrep-all
      wiki-tui
      kondo
      p7zip
      uutils-coreutils-noprefix
      hyperfine
      delta
    ];
  };
}

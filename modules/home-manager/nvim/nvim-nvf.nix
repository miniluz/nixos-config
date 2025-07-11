{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
let
  cfg = config.miniluz.nvim-nvf;
in
{
  imports = [
    inputs.nvf.homeManagerModules.default
    ../firacode.nix
    ../direnv.nix
  ];

  options.miniluz.nvim-nvf.enable = lib.mkEnableOption "Enable Neovim.";

  config = lib.mkIf cfg.enable {
    miniluz.direnv.enable = true;
    miniluz.firacode.enable = true;

    programs.nvf = {
      enable = true;
      settings.vim = {
        theme = {
          name = "catppuccin";
          style = "macchiato";
          transparent = true;
        };

        viAlias = false;
        vimAlias = true;

        lsp = {
          enable = true;
        };

        languages.nix.enable = true;

        statusline.lualine.enable = true;
        telescope.enable = true;
        autocomplete.blink-cmp.enable = true;
        binds.whichKey.enable = true;
        filetree.neo-tree.enable = true;
      };
    };

    home.packages = with pkgs; [
      nixd
      nixfmt-rfc-style
    ];

    programs.neovide = {
      enable = true;
    };
  };
}

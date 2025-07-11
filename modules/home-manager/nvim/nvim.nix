{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
let
  cfg = config.miniluz.nvim;
in
{
  imports = [
    inputs.nvf.homeManagerModules.default
    ../firacode.nix
    ../direnv.nix
  ];

  options.miniluz.nvim.enable = lib.mkEnableOption "Enable Neovim.";

  config = lib.mkIf cfg.enable {
    miniluz.direnv.enable = true;
    miniluz.firacode.enable = true;

    programs.nvf = {
      enable = true;
      settings.vim = {
        viAlias = false;
        vimAlias = true;

        lsp = {
          enable = true;
        };

        languages.nix.enable = true;

        statusline.lualine.enable = true;
        telescope.enable = true;
        autocomplete.nvim-cmp.enable = true;
        binds.whichKey.enable = true;
      };
    };

    home.packages = with pkgs; [
      nixd
      nixfmt-rfc-style
    ];
  };
}

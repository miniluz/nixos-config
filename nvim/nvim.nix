{
  imports = [
    ./nvim-bufferline.nix
    ./nvim-comments.nix
    ./nvim-extra-languages.nix
    ./nvim-guess-indent.nix
    ./nvim-legendary.nix
    ./nvim-nix.nix
    ./nvim-nvimtree.nix
    ./nvim-snacks.nix
    ./nvim-toggleterm.nix
    ./nvim-ts.nix
    ./nvim-windsurf.nix
    ./nvim-vscode-mappings.nix
  ];

  config.vim = {
    theme = {
      enable = true;
      name = "catppuccin";
      style = "macchiato";
      transparent = true;
    };

    viAlias = false;
    vimAlias = true;

    treesitter.enable = true;
    lsp.enable = true;
    lsp.trouble.enable = true;
    diagnostics = {
      enable = true;
      config.virtual_text = true;
    };

    languages = {
      enableTreesitter = true;
      enableFormat = true;
      enableDAP = true;
    };

    statusline.lualine.enable = true;
    autocomplete.blink-cmp.enable = true;
    binds.whichKey.enable = true;
    autopairs.nvim-autopairs.enable = true;

  };
}

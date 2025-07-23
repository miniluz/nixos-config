{
  imports = [
    ./nvim-bufferline.nix
    ./nvim-codecompanion.nix
    ./nvim-comments.nix
    ./nvim-extra-languages.nix
    ./nvim-guess-indent.nix
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
    lsp = {
      enable = true;
      trouble.enable = true;
      formatOnSave = true;
    };

    diagnostics = {
      enable = true;
      config.virtual_text = true;
    };

    git.enable = true;

    languages = {
      enableTreesitter = true;
      enableFormat = true;
      enableDAP = true;
    };
    formatter.conform-nvim.enable = true;

    statusline.lualine.enable = true;
    autocomplete.blink-cmp.enable = true;
    binds.whichKey.enable = true;
    autopairs.nvim-autopairs.enable = true;
    projects.project-nvim.enable = true;

  };
}

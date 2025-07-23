{
  imports = [
    ./ia/nvim-codecompanion.nix
    ./ia/nvim-windsurf.nix
    ./ide/nvim-bufferline.nix
    ./ide/nvim-nvimtree.nix
    # ./ide/nvim-snacks-dashboard.nix
    ./ide/nvim-snacks-picker.nix
    ./ide/nvim-toggleterm.nix
    ./ide/nvim-vscode-mappings.nix
    ./ide/nvim-window-jumps.nix
    ./languages/nvim-extra-languages.nix
    ./languages/nvim-nix.nix
    ./languages/nvim-ts.nix
    ./utils/nvim-comments.nix
    ./utils/nvim-guess-indent.nix
    ./utils/nvim-snacks-utils.nix
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

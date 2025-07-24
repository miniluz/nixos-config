{
  imports = [
    ./ia/nvim-codecompanion.nix
    ./ia/nvim-windsurf.nix
    ./ide/nvim-bufferline.nix
    ./ide/nvim-nvimtree.nix
    ./ide/nvim-snacks-dashboard.nix
    ./ide/nvim-snacks-picker.nix
    ./ide/nvim-toggleterm.nix
    ./ide/nvim-vscode-mappings.nix
    ./languages/nvim-extra-languages.nix
    ./languages/nvim-nix.nix
    ./languages/nvim-rust.nix
    ./languages/nvim-ts.nix
    ./utils/nvim-comments.nix
    ./utils/nvim-guess-indent.nix
    ./utils/nvim-mini-utils.nix
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
      formatOnSave = true;
      inlayHints.enable = true;
      trouble.enable = true;

      lspsaga.enable = true;
    };

    diagnostics = {
      enable = true;
      nvim-lint.enable = true;
      config.virtual_text = true;
    };

    git.enable = true;

    languages = {
      enableTreesitter = true;
      enableFormat = true;
      enableDAP = true;
    };
    formatter.conform-nvim.enable = true;
    debugger.nvim-dap = {
      enable = true;
      ui.enable = true;
    };

    snippets.luasnip.enable = true;

    utility = {
      # undotree.enable = true;
      direnv.enable = true;
      images = {
        image-nvim.enable = true;
        img-clip.enable = true;
      };
    };

    visuals.fidget-nvim.enable = true;
    ui.nvim-ufo.enable = true;

    statusline.lualine.enable = true;
    projects.project-nvim.enable = true;

  };
}

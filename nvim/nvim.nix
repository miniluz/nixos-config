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
    ./languages/nvim-i18n.nix
    ./languages/nvim-nix.nix
    ./languages/nvim-rust.nix
    ./languages/nvim-ts.nix
    ./utils/nvim-comments.nix
    ./utils/nvim-mini-utils.nix
    ./utils/nvim-snacks-utils.nix
    ./utils/nvim-utils.nix
    ./nvim-lsp.nix
  ];

  config.vim = {
    theme = {
      enable = true;
      name = "catppuccin";
      style = "macchiato";
      transparent = false;
    };

    viAlias = false;
    vimAlias = true;

  };
}

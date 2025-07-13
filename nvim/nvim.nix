{
  pkgs,
  ...
}:
{
  imports = [
    ./nvim-comments.nix
    ./nvim-extra-languages.nix
    ./nvim-guess-indent.nix
    ./nvim-legendary.nix
    ./nvim-nix.nix
    ./nvim-nvimtree.nix
    ./nvim-snacks.nix
    ./nvim-toggleterm.nix
    ./nvim-ts.nix
  ];

  config.vim = {
    theme = {
      name = "tokyonight";
      # style = "macchiato";
      transparent = true;
    };

    viAlias = false;
    vimAlias = true;

    treesitter.enable = true;
    lsp.enable = true;
    lsp.trouble.enable = true;

    languages = {
      enableTreesitter = true;
      enableFormat = true;
      enableDAP = true;
    };

    statusline.lualine.enable = true;
    autocomplete.blink-cmp.enable = true;
    binds.whichKey.enable = true;
    autopairs.nvim-autopairs.enable = true;

    keymaps = [
      {
        key = "<C-S-c>";
        mode = [
          "n"
        ];
        silent = true;
        action = "\"+yy";
      }
      {
        key = "<C-S-c>";
        mode = [
          "v"
        ];
        silent = true;
        action = "\"+y";
      }
      {
        key = "<C-S-v>";
        mode = [
          "n"
          "v"
        ];
        silent = true;
        action = "\"+p";
      }
      {
        key = "<C-S-v>";
        mode = [
          "i"
        ];
        silent = true;
        action = "<esc>\"+po";
      }
      {
        key = "<C-s>";
        mode = [
          "n"
          "v"
          "i"
        ];
        silent = true;
        action = "<leader>lf :w <cr>";
      }

      {
        key = "<leader>w";
        mode = [
          "n"
          "v"
        ];
        silent = true;
        action = "<leader>lf :w <bar> :bd<cr>";
      }
    ];
  };
}

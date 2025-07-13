{
  pkgs,
  ...
}:
{
  imports = [
    ./nvim-extra-languages.nix
    ./nvim-guess-indent.nix
    ./nvim-legendary.nix
    ./nvim-nix.nix
    ./nvim-nvimtree.nix
    ./nvim-snacks.nix
    ./nvim-toggleterm.nix
  ];

  config.vim = {
    # theme = {
    # name = "catppuccin";
    #  style = "macchiato";
    #  transparent = true;
    # };

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
    tabline.nvimBufferline.enable = true;
    comments.comment-nvim.enable = true;
    autopairs.nvim-autopairs.enable = true;

    keymaps = [
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
          "i"
        ];
        silent = true;
        action = "\"+p";
      }
      {
        key = "<leader>w";
        mode = [
          "n"
          "v"
        ];
        silent = true;
        action = ":w <bar> :bd<cr>";
      }
    ];
  };
}

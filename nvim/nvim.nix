{
  config.vim = {
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
    autocomplete.blink-cmp.enable = true;
    binds.whichKey.enable = true;
    filetree.neo-tree.enable = true;

    telescope.enable = true;

    keymaps = [
      {
        key = "<C-p>";
        mode = [
          "n"
          "v"
        ];
        silent = true;
        action = "<cmd>Telescope find_files<cr>";
      }
      {
        key = "<C-S-p>";
        mode = [
          "n"
          "v"
        ];
        silent = true;
        action = "<cmd>Telescope commands<cr>";
      }
      {
        key = "<C-t>";
        mode = [
          "n"
          "v"
        ];
        silent = true;
        action = "<cmd>Neotree toggle right<cr>";
      }
      {
        key = "<C-S-c>";
        mode = [
          "v"
        ];
        silent = true;
        action = "\"*y";
      }
      {
        key = "<C-S-p>";
        mode = [
          "v"
        ];
        silent = true;
        action = "\"*p";
      }
    ];
  };
}

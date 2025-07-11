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
    telescope.enable = true;
    autocomplete.blink-cmp.enable = true;
    binds.whichKey.enable = true;
    filetree.neo-tree.enable = true;
  };
}

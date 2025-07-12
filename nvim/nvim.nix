{
  pkgs,
  ...
}:
{
  imports = [
    ./nvim-neotree.nix
    ./nvim-telescope.nix
    ./nvim-legendary.nix
  ];

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

    languages = {
      enableTreesitter = true;
      enableFormat = true;
      enableDAP = true;
    };

    languages.nix = {
      enable = true;
      lsp.server = "nixd";
      format.package = pkgs.nixfmt-rfc-style;
    };

    statusline.lualine.enable = true;
    autocomplete.blink-cmp.enable = true;
    binds.whichKey.enable = true;

    keymaps = [
      {
        key = "<C-S-c>";
        mode = [
          "v"
        ];
        silent = true;
        action = "\"*y";
      }
      {
        key = "<C-S-v>";
        mode = [
          "n"
          "v"
          "i"
        ];
        silent = true;
        action = "\"*p";
      }
    ];
  };
}

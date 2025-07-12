{ pkgs, ... }:
{
  config.vim = {
    lazy.plugins."legendary.nvim" = {
      package = pkgs.vimPlugins.legendary-nvim;
      setupModule = "legendary";

      setupOpts = {
        extensions = {
          which_key = {
            auto_register = false;
          };
        };
      };

      keys = [
        {
          key = "<C-S-p>";
          mode = [
            "n"
            "v"
          ];
          silent = true;
          action = "<cmd>Legendary<cr>";
        }
      ];
    };

  };

}

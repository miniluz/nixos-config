{ pkgs, ... }:
{
  config.vim = {
    extraPlugins = {
      legendary = {
        # ^^^^^^^^^ this name should match the package.pname or package.name
        package = pkgs.vimPlugins.legendary-nvim;

        setup = "require('legendary').setup({ extensions = {
          lazy_nvim = true,
          which_key = {
            auto_register = false,
          },
        }});";

        # before = [ "which-key" ];
      };
    };

    keymaps = [
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

}

{ pkgs, ... }:
{
  config.vim = {
    lazy.plugins."toggleterm.nvim" = {
      package = pkgs.vimPlugins.toggleterm-nvim;

      setupModule = "toggleterm";

      setupOpts = {
        direction = "float";
      };

      after = ''
        local Terminal  = require('toggleterm.terminal').Terminal

        local gitui_terminal = Terminal:new({ cmd = "gitui", hidden = true })

        function _gitui_toggle()
          gitui_terminal:toggle()
        end

        local zellij_terminal = Terminal:new({ cmd = "zellij", hidden = true })

        function _zellij_toggle()
          zellij_terminal:toggle()
        end
      '';

      keys = [

        {
          key = "<C-+>";
          mode = [
            "n"
            "t"
          ];
          silent = true;
          action = ''<cmd>lua _gitui_toggle()<cr>'';
          desc = "Toggle GitUI terminal.";
        }
        {
          key = "<C-¡>";
          mode = [
            "n"
            "t"
          ];
          silent = true;
          action = ''<cmd>lua _zellij_toggle()<cr>'';
          desc = "Exit terminal mode.";
        }
      ];
    };

    keymaps = [
      {
        key = "<C-º>";
        mode = "t";
        silent = true;
        action = ''<C-\><C-n>'';
        desc = "Exit terminal mode.";
      }
    ];

  };

}

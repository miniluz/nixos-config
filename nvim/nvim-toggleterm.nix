{ pkgs, ... }:
{
  config.vim = {
    lazy.plugins."toggleterm.nvim" = {
      package = pkgs.vimPlugins.toggleterm-nvim;

      setupModule = "toggleterm";

      setupOpts = {
        direction = "float";
      };

      keys = [

        {
          key = "<C-+>";
          mode = "n";
          silent = true;
          action = ''<cmd>1TermExec cmd="gitui"<cr>'';
          desc = "Toggle GitUI terminal.";
        }
        {
          key = "<C-+>";
          mode = "t";
          silent = true;
          action = ''<cmd>1ToggleTerm<cr>'';
          desc = "Toggle GitUI terminal.";
        }
        {
          key = "<C-`>";
          mode = "n";
          silent = true;
          action = ''<cmd>2TermExec cmd="zellij"<cr>'';
          desc = "Exit terminal mode.";
        }
        {
          key = "<C-`>";
          mode = "t";
          silent = true;
          action = ''<cmd>2ToggleTerm<cr>'';
          desc = "Exit terminal mode.";
        }
      ];
    };

    keymaps = [
      {
        key = "<C-'>";
        mode = "t";
        silent = true;
        action = ''<C-\><C-n>'';
        desc = "Exit terminal mode.";
      }
    ];

  };

}

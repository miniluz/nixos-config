{ pkgs, ... }:
{
  config.vim = {
    terminal.toggleterm = {
      enable = true;

      mappings.open = "<C+`>";

      setupOpts = {
        direction = "float";
      };
    };

    keymaps = [
      {
        key = "<leader>gg";
        mode = "n";
        silent = true;
        action = ''<cmd>1ToggleTerm | 1TermExec cmd="gitui"<cr>'';
        desc = "Toggle GitUI terminal.";
      }
      {
        key = "<C+º>";
        mode = "t";
        silent = true;
        action = ''<C+\><C+n>'';
        desc = "Exit terminal mode.";
      }
      {
        key = "<C+`>";
        mode = "t";
        silent = true;
        action = ''<cmd>ToggleTermToggleAll<cr>'';
        desc = "Exit terminal mode.";
      }

    ];

  };

}

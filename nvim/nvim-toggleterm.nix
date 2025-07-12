{ pkgs, ... }:
{
  config.vim = {
    terminal.toggleterm = {
      enable = true;

      mappings.open = "<C-\\>";

      setupOpts = {
        direction = "float";
      };
    };

    keymaps = [
      {
        key = "<C-'>";
        mode = "t";
        silent = true;
        action = ''<C-\><C-n>'';
        desc = "Exit terminal mode.";
      }
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

}

{
  config.vim = {
    keymaps = [
      # Window navigation
      {
        key = "<C-Left>";
        mode = [ "n" ];
        silent = true;
        action = "<C-w>h";
      }
      {
        key = "<C-Down>";
        mode = [ "n" ];
        silent = true;
        action = "<C-w>j";
      }
      {
        key = "<C-Up>";
        mode = [ "n" ];
        silent = true;
        action = "<C-w>k";
      }
      {
        key = "<C-Right>";
        mode = [ "n" ];
        silent = true;
        action = "<C-w>l";
      }

      # Window movement (drag)
      {
        key = "<C-S-Left>";
        mode = [ "n" ];
        silent = true;
        action = "<C-w>H";
      }
      {
        key = "<C-S-Down>";
        mode = [ "n" ];
        silent = true;
        action = "<C-w>J";
      }
      {
        key = "<C-S-Up>";
        mode = [ "n" ];
        silent = true;
        action = "<C-w>K";
      }
      {
        key = "<C-S-Right>";
        mode = [ "n" ];
        silent = true;
        action = "<C-w>L";
      }
    ];
  };
}

{
  config.vim = {
    filetree.nvimTree = {
      enable = true;
      setupOpts = {
        actions = {
          open_file = {
            quit_on_open = true;
          };
        };
        view = {
          side = "right";
        };
      };
    };
    keymaps = [
      {
        key = "<leader>e";
        mode = [
          "n"
          "v"
        ];
        silent = true;
        action = "<cmd>NvimTreeFindFileToggle<cr>";
      }
    ];
  };

}

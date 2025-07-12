{
  config.vim = {
    telescope.enable = true;

    keymaps = [
      {
        key = "<C-p>";
        mode = [
          "n"
          "v"
        ];
        silent = true;
        action = "<cmd>Telescope find_files<cr>";
      }
      # {
      #   key = "<C-S-p>";
      #   mode = [
      #     "n"
      #     "v"
      #   ];
      #   silent = true;
      #   action = "<cmd>Telescope commands<cr>";
      # }
    ];
  };

}

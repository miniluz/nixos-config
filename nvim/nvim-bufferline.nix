{
  config.vim = {
    tabline.nvimBufferline.enable = true;

    keymaps = [
      {
        key = "<Right>";
        mode = [
          "n"
          "v"
        ];
        silent = true;
        action = "<cmd>BufferLineCycleNext<cr>";
      }
      {
        key = "<Left>";
        mode = [
          "n"
          "v"
        ];
        silent = true;
        action = "<cmd>BufferLineCyclePrev<cr>";
      }
      {
        key = "<C-Right>";
        mode = [
          "n"
          "v"
        ];
        silent = true;
        action = "<cmd>BufferLineMoveNext<cr>";
      }
      {
        key = "<C-Left>";
        mode = [
          "n"
          "v"
        ];
        silent = true;
        action = "<cmd>BufferLineMovePrev<cr>";
      }
      {
        key = "<Up>";
        mode = [
          "n"
          "v"
        ];
        silent = true;
        action = "<cmd>BufferLineMovePick<cr>";
      }
    ];
  };
}

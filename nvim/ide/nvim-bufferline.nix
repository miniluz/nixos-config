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
        key = "<Up>";
        mode = [
          "n"
          "v"
        ];
        silent = true;
        action = "<cmd>BufferLinePick<cr>";
      }
    ];
  };
}

{
  config.vim = {
    keymaps = [
      {
        key = "<C-S-c>";
        mode = [
          "n"
        ];
        silent = true;
        action = "\"+yy";
      }
      {
        key = "<C-S-c>";
        mode = [
          "v"
        ];
        silent = true;
        action = "\"+y";
      }
      {
        key = "<C-S-v>";
        mode = [
          "n"
          "v"
        ];
        silent = true;
        action = "\"+p";
      }
      {
        key = "<C-S-v>";
        mode = [
          "i"
        ];
        silent = true;
        action = "<esc>\"+po";
      }
      {
        key = "<C-s>";
        mode = [
          "n"
          "v"
          "i"
        ];
        silent = true;
        action = "<cmd>w<cr>";
      }

      {
        key = "<leader>w";
        mode = [
          "n"
          "v"
        ];
        silent = true;
        action = "<cmd>w<cr><cmd>bd<cr>";
      }
      {
        key = "<C-.>";
        mode = [
          "n"
          "v"
          "i"
        ];
        silent = true;
        action = "<cmd>lua vim.lsp.buf.code_action()<cr>";
      }
      {
        key = "<F2>";
        mode = [ "n" ];
        silent = true;
        action = "<leader>ln";
      }
    ];
  };
}

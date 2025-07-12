{
  config.vim = {
    filetree.neo-tree.enable = true;
    keymaps = [
      {
        key = "<leader>e";
        mode = [
          "n"
          "v"
        ];
        silent = true;
        action = "<cmd>Neotree toggle right<cr>";
      }
    ];
  };

}

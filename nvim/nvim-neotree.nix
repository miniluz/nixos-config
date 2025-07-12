{
  config.vim = {
    filetree.neo-tree.enable = true;
    keymaps = [
      {
        key = "<C-t>";
        mode = [
          "n"
          "v"
        ];
        silent = true;
        action = "<cmd>Neotree toggle right<cr>";
        desc = "Toggle file tree";
      }
      {
        key = "<C-S-t>";
        mode = [
          "n"
          "v"
        ];
        silent = true;
        action = "<cmd>Neotree float git_status<cr>";
        desc = "Toggle git status tree";
      }
    ];
  };

}

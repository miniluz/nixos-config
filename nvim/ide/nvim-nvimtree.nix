{
  config.vim = {
    filetree.nvimTree = {
      enable = true;
      setupOpts = {
        actions.open_file.quit_on_open = true;

        diagnostics = {
          enable = true;
          show_on_dirs = true;
          show_on_open_dirs = false;
        };
        modified.enable = true;

        git.enable = true;

        renderer = {
          add_trailing = true;
          full_name = true;
          group_empty = true;
          highlight_modified = "icon";
          highlight_opened_files = "icon";
        };

        update_focused_file = {
          enable = true;
          update_root = true;
        };
        sync_root_with_cwd = true;

        view = {
          float.enable = true;
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

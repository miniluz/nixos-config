{
  pkgs,
  ...
}:
{
  config.vim = {
    git.enable = true;

    autocomplete.nvim-cmp.enable = true;

    binds.whichKey.enable = true;

    utility = {
      # undotree.enable = true;
      direnv.enable = true;
      motion.leap.enable = true;
    };

    visuals.fidget-nvim.enable = true;
    ui.nvim-ufo.enable = true;

    statusline.lualine.enable = true;
    projects.project-nvim.enable = true;

    notes.todo-comments.enable = true;

    lazy.plugins = {
      "flit.nvim" = {
        package = pkgs.vimPlugins.flit-nvim;
        setupModule = "flit";
        lazy = false;
      };
      "nvim-spider" = {
        package = pkgs.vimPlugins.nvim-spider;
        setupModule = "spider";
        lazy = false;
        keys = [
          {
            key = "w";
            action = "<cmd>lua require('spider').motion('w')<CR>";
            mode = [
              "n"
              "o"
              "x"
            ];
            silent = true;
          }
          {
            key = "e";
            action = "<cmd>lua require('spider').motion('e')<CR>";
            mode = [
              "n"
              "o"
              "x"
            ];
            silent = true;
          }
          {
            key = "b";
            action = "<cmd>lua require('spider').motion('b')<CR>";
            mode = [
              "n"
              "o"
              "x"
            ];
            silent = true;
          }
        ];
      };
    };
  };
}

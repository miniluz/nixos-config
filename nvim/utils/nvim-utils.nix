{
  pkgs,
  lib,
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

    statusline.lualine.enable = true;
    projects.project-nvim.enable = true;

    notes.todo-comments.enable = true;

    options = {
      foldcolumn = "1";
      foldlevel = 99;
      foldlevelstart = 99;
      foldenable = true;
    };

    autopairs.nvim-autopairs.enable = true;

    ui.noice.enable = true;

    ui.nvim-ufo = {
      enable = true;
      setupOpts.providerSelector = lib.generators.mkLuaInline ''
        function(bufnr, filetype, buftype)
          return { "treesitter", "indent" }
        end
      '';
    };

    lazy.plugins = {
      "specs.nvim" = {
        package = pkgs.vimPlugins.specs-nvim;
        setupModule = "specs";
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

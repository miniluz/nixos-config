{
  pkgs,
  ...
}:
{
  config.vim = {
    git.enable = true;

    autocomplete.nvim-cmp.enable = true;

    utility = {
      # undotree.enable = true;
      direnv.enable = true;
      motion.leap.enable = true;
    };

    visuals.fidget-nvim.enable = true;
    # ui.nvim-ufo.enable = true;

    statusline.lualine.enable = true;
    projects.project-nvim.enable = true;

    notes.todo-comments.enable = true;

    lazy.plugins = {
      "flit.nvim" = {
        package = pkgs.vimPlugins.flit-nvim;
        setupModule = "flit";
      };
      "nvim-spider" = {
        package = pkgs.vimPlugins.nvim-spider;
        setupModule = "spider";
      };
    };
  };
}

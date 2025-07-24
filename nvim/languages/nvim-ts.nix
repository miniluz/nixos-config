{ pkgs, ... }:
{
  config.vim = {
    languages = {
      ts = {
        enable = true;
        format.type = "prettierd";
      };
      tailwind.enable = true;
      css.enable = true;
      html.enable = true;
    };
    lazy.plugins = {
      "tailwind-tools.nvim" = {
        package = pkgs.vimPlugins.tailwind-tools-nvim;
        setupModule = "tailwind-tools";
        lazy = false;
      };
    };
  };
}

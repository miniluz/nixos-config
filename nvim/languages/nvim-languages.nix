{ pkgs, ... }:
{
  config.vim = {
    lazy.plugins = {
      "neoconf.nvim" = {
        package = pkgs.vimPlugins.neoconf-nvim;
        setupModule = "neoconf";
      };
    };
  };
}

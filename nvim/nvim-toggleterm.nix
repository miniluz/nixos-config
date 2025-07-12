{ pkgs, ... }:
{
  config.vim = {
    terminal.toggleterm = {
      enable = true;
      setupOpts = {
        direction = "tab";
      };
    };

  };

}

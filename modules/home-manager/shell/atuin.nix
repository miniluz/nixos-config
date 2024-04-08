{ config, pkgs, lib, ... }:
let
  cfg = config.miniluz.atuin;
in
{
  options.miniluz.atuin.enable = lib.mkEnableOption "Enable Atuin.";

  config = lib.mkIf cfg.enable {
    programs.atuin.enable = true;

    programs.atuin.settings = {
      sytle = "compact";
      inline_height = 10;
    };
  };
}

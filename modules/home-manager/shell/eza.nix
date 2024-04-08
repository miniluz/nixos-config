{ config, lib, ... }:
let
  cfg = config.miniluz.eza;
in
{
  options.miniluz.eza.enable = lib.mkEnableOption "Enable eza.";

  config = lib.mkIf cfg.enable {
    programs.eza.enable = true;
    programs.zsh.initExtra = "alias exal=\"eza --long --header --icons --git\"";
  };
}

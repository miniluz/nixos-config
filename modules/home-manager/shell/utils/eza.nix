{ config, lib, ... }:
let
  cfg = config.miniluz.eza;
in
{
  options.miniluz.eza.enable = lib.mkEnableOption "Enable eza.";

  config =
    let
      command = "eza --long --header --icons --git";
    in
    lib.mkIf cfg.enable {
      programs.eza.enable = true;
      programs.zsh.initExtra = "alias exal=\"${command}\"";
      programs.fish.shellAliases.exal = command;
    };
}

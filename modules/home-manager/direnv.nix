{ config, pkgs, lib, ... }:
let
  cfg = config.miniluz.direnv;
in
{
  options.miniluz.direnv.enable = lib.mkEnableOption "Enable Direnv.";

  config = lib.mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };
}

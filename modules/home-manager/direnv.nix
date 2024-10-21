{ config, pkgs, lib, ... }:
let
  cfg = config.miniluz.direnv;
in
{
  imports = [ ./shell/fish.nix ];

  options.miniluz.direnv.enable = lib.mkEnableOption "Enable Direnv.";

  config = lib.mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}

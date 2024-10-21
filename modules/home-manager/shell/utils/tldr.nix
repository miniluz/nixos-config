{ config, pkgs, lib, ... }:
let
  cfg = config.miniluz.tldr;
in
{
  options.miniluz.tldr.enable = lib.mkEnableOption "Enable Vesktop.";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.tldr
    ];
  };
}

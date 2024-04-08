{ config, pkgs, lib, ... }:
let
  cfg = config.miniluz.vesktop;
in
{
  options.miniluz.vesktop.enable = lib.mkEnableOption "Enable Vesktop.";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.vesktop
    ];
  };
}

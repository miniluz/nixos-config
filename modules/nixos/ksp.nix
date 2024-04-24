{ config, lib, pkgs, ... }:
let
  cfg = config.miniluz.ksp;
in
{
  options.miniluz.ksp.enable = lib.mkEnableOption "Enable KSP dependencies.";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.bottles
      pkgs.ckan
    ];

    fonts.packages = [
      pkgs.corefonts
      pkgs.vistafonts
    ];
  };
}

{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.miniluz.ksp;
in
{
  options.miniluz.ksp.enable = lib.mkEnableOption "Enable KSP dependencies.";

  config = lib.mkIf cfg.enable {
    fonts.fontconfig.enable = true;

    home.packages = [
      pkgs.bottles
      pkgs.ckan
      pkgs.corefonts
    ];
  };
}

{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.miniluz.helm;
in
{
  options.miniluz.helm.enable = lib.mkEnableOption "Enable Helm.";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.helm
    ];
  };
}

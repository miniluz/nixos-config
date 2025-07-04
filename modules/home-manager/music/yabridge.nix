{
  config,
  pkgs,
  lib,
  paths,
  ...
}:
let
  cfg = config.miniluz.yabridge;
in
{
  imports = [
    "${paths.homeManager}/bottles.nix"
  ];

  options.miniluz.yabridge.enable = lib.mkEnableOption "Enable yabridge.";

  config = lib.mkIf cfg.enable {
    miniluz.bottles.enable = true;

    home.packages = with pkgs; [
      yabridge
      yabridgectl
    ];
  };
}

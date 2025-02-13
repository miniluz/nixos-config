{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  cfg = config.miniluz.music;
  musicModules = "${inputs.self}/modules/home-manager/music";
in
{
  imports = [
    "${musicModules}/reaper.nix"
    "${musicModules}/helm.nix"
    "${musicModules}/yabridge.nix"
  ];

  options.miniluz.music.enable = lib.mkEnableOption "Enable all of my music production configuration.";

  config = lib.mkIf cfg.enable {
    miniluz.reaper.enable = true;
    # miniluz.helm.enable = true;
    miniluz.yabridge.enable = true;
  };
}

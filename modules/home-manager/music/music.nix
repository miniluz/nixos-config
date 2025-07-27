{
  config,
  lib,
  ...
}:
let
  cfg = config.miniluz.music;
in
{
  imports = [
    ./reaper.nix
    ./helm.nix
    ./yabridge.nix
  ];

  options.miniluz.music.enable = lib.mkEnableOption "Enable all of my music production configuration.";

  config = lib.mkIf cfg.enable {
    miniluz.reaper.enable = true;
    miniluz.helm.enable = true;
    miniluz.yabridge.enable = true;
  };
}

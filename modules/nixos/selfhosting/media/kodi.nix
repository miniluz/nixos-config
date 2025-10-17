{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.miniluz.selfhosting;
in
{
  options.miniluz.selfhosting.kodi = lib.mkEnableOption "Kodi";

  config = lib.mkIf (config.miniluz.visual && cfg.enable && cfg.kodi && !cfg.server.enable) {
    users.users.miniluz.packages = [
      (pkgs.kodi.withPackages (
        kodiPkgs: with kodiPkgs; [
          jellyfin
        ]
      ))
    ];
  };
}

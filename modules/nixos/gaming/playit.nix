{
  config,
  pkgs,
  lib,
  paths,
  ...
}:
let
  cfg = config.miniluz.playit;
in
{
  options.miniluz.gaming.enable = lib.mkEnableOption "Enable PlayIt.";

  config = lib.mkIf cfg.enable {
    age.secrets.playit.file = "${paths.secrets}/playit.age";

    services.playit = {
      enable = true;
      user = "playit";
      group = "playit";
      secretPath = config.age.secrets.playit.path;
    };
  };
}

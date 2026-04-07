{
  config,
  lib,
  ...
}:
let
  cfg = config.miniluz.selfhosting;
  inherit (config.miniluz.constants) host-secrets;
in
{
  config = lib.mkIf (cfg.enable && cfg.jellyfin && cfg.server.enable) {

    age.secrets.recyclarr-keys = {
      file = "${host-secrets}/recyclarr-keys.age";
      owner = "recyclarr";
      group = "recyclarr";
    };

    systemd.services.recyclarr.serviceConfig.EnvironmentFile = [
      "${config.age.secrets.recyclarr-keys.path}"
    ];

    nixarr.recyclarr = {
      enable = true;
      configFile = ./recyclarr.yaml;
    };

  };
}

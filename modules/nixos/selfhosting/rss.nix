{
  config,
  lib,
  host-secrets,
  ...
}:
let
  cfg = config.miniluz.selfhosting;
in
{
  options.miniluz.selfhosting.rss = lib.mkEnableOption "RSS";

  config = lib.mkIf (cfg.enable && cfg.rss && cfg.server.enable) {
    age.secrets.miniflux-admin.file = "${host-secrets}/miniflux-admin.age"; # Create the systemd service

    services.miniflux = {
      enable = true;
      adminCredentialsFile = config.age.secrets.miniflux-admin.path;
      config.LISTEN_ADDR = "127.0.0.1:7882";
    };

  };

}

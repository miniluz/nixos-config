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
  options.miniluz.selfhosting.searxng = lib.mkEnableOption "SearXNG";

  config = lib.mkIf (cfg.enable && cfg.searxng && cfg.server.enable) {
    age.secrets.searxng-key.file = "${host-secrets}/searxng-key.age"; # Create the systemd service

    services.searx = {
      enable = true;
      environmentFile = config.age.secrets.searxng-key.path;
      settings = {
        server.port = 7881;
        server.bind_address = "127.0.0.1";
        server.secret_key = "$SEARX_SECRET_KEY";
      };
    };

  };

}

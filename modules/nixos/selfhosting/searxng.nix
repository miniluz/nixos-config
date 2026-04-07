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
  options.miniluz.selfhosting.searxng = lib.mkEnableOption "SearXNG";

  config = lib.mkIf (cfg.enable && cfg.searxng && cfg.server.enable) {
    age.secrets.searxng-key.file = "${host-secrets}/searxng-key.age";

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

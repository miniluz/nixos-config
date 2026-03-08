{
  config,
  lib,
  ...
}:
let
  cfg = config.miniluz.selfhosting;
in
{
  options.miniluz.selfhosting.searxng = lib.mkEnableOption "SearXNG";

  config = lib.mkIf (cfg.enable && cfg.searxng && cfg.server.enable) {

    services.searx = {
      enable = true;
      settings = {
        server.port = 7881;
        server.bind_address = "127.0.0.1";
      };
    };

  };

}

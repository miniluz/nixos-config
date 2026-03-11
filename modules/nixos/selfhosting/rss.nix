{
  pkgs,
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
    age.secrets.miniflux-admin.file = "${host-secrets}/miniflux-admin.age";

    services.miniflux = {
      enable = true;
      adminCredentialsFile = config.age.secrets.miniflux-admin.path;
      config.LISTEN_ADDR = "127.0.0.1:7882";
    };

    miniluz.selfhosting.backups.backups.miniflux =
      let
        extractionPath = "/tmp/miniflux-dump";
        filename = "miniflux_dump.sql";
      in
      {
        paths = [
          extractionPath
        ];
        preHook = ''
          echo "Generating postgres dump"

          echo "Creating path to extract at"
          mkdir -p ${extractionPath}

          echo "Extracting"
          ${lib.getExe pkgs.sudo} -u miniflux ${lib.getExe' pkgs.postgresql "pg_dump"} miniflux > "${extractionPath}/${filename}"

          echo "Extracted to ${extractionPath}/${filename}"
        '';
      };

  };

}

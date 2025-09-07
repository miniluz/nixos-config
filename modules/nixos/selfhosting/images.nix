{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.miniluz.selfhosting;
  serverStorage = config.miniluz.selfhosting.server.serverStorage;
  mediaLocation = "${serverStorage}/immich";
in
{
  options.miniluz.selfhosting.immich = lib.mkEnableOption "Immich";

  config = lib.mkIf (cfg.enable && cfg.immich && cfg.server.enable) {

    users.users.immich = {
      home = mediaLocation;
      createHome = true;
    };

    services.immich = {
      inherit mediaLocation;
      enable = true;
      host = "0.0.0.0";
      # openFirewall = true;
      # TODO accelerationDevices = []
    };

    miniluz.selfhosting.backups.backups.immich =
      let
        extractionPath = "/tmp/immich-dump";
        filename = "immich_dump.sql";
      in
      {
        paths = [
          mediaLocation
          extractionPath
        ];
        preHook = ''
          echo "Generating postgres dump"

          echo "Creating path to extract at"
          mkdir -p ${extractionPath}

          echo "Extracting"
          ${lib.getExe pkgs.sudo} -u immich ${lib.getExe' pkgs.postgresql "pg_dump"} immich > "${extractionPath}/${filename}"

          echo "Extracted to ${extractionPath}/${filename}"
        '';
      };
  };

}

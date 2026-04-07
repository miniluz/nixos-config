{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.miniluz.selfhosting;
  inherit (config.miniluz.constants) host-secrets;

  serverStorage = config.miniluz.selfhosting.server.serverStorage;
  home = "${serverStorage}/nextcloud";
in
{
  options.miniluz.selfhosting.nextcloud = lib.mkOption {
    default = true;
    description = "Enable NextCloud";
  };

  config = lib.mkIf (cfg.enable && cfg.nextcloud) (
    lib.mkMerge [
      (lib.mkIf (!cfg.server.enable) {
        environment.systemPackages = [ pkgs.nextcloud-client ];
      })
      (lib.mkIf cfg.server.enable {

        age.secrets.nextcloud-pass = {
          file = "${host-secrets}/nextcloud-pass.age";
          owner = "nextcloud";
          group = "nextcloud";
        };

        systemd.tmpfiles.rules = [
          "d ${home} 0750 nextcloud nextcloud"
        ];

        services.nginx.virtualHosts."${config.services.nextcloud.hostName}" = {
          useACMEHost = "home.miniluz.dev";
          forceSSL = true;
        };

        services.nextcloud = {
          enable = true;
          package = pkgs.nextcloud33;

          inherit home;

          configureRedis = true;

          database.createLocally = true;
          config = {
            dbtype = "pgsql";
            adminpassFile = config.age.secrets.nextcloud-pass.path;
          };
          maxUploadSize = "100G";

          https = true;
          hostName = "cloud.home.miniluz.dev";
        };

        miniluz.selfhosting.backups.backups.nextcloud =
          let
            extractionPath = "/tmp/nextcloud-dump";
            filename = "nextcloud_dump.sql";
          in
          {
            paths = [
              home
              extractionPath
            ];
            preHook = ''
              echo "Generating postgres dump"

              echo "Creating path to extract at"
              mkdir -p ${extractionPath}

              echo "Extracting"
              ${lib.getExe pkgs.sudo} -u nextcloud ${lib.getExe' pkgs.postgresql "pg_dump"} nextcloud > "${extractionPath}/${filename}"

              echo "Extracted to ${extractionPath}/${filename}"
            '';
          };
      })
    ]
  );

}

{
  pkgs,
  inputs,
  config,
  lib,
  host-secrets,
  ...
}:
let
  cfg = config.miniluz.selfhosting;

  serverStorage = config.miniluz.selfhosting.server.serverStorage;
  dataDir = "${serverStorage}/actual";

  actual-backup = inputs.actual-backup.packages.${pkgs.system}.actual-backup.forNixpkgsActualServer;
in
{
  options.miniluz.selfhosting.actual = lib.mkEnableOption "Actual";

  config = lib.mkIf (cfg.enable && cfg.actual && cfg.server.enable) {

    age.secrets.actual-sync-id.file = "${host-secrets}/actual-sync-id.age";
    age.secrets.actual-password.file = "${host-secrets}/actual-password.age";

    services.actual = {
      enable = true;
      # openFirewall = true;

      settings = {
        inherit dataDir;
        port = 9991;
      };
    };

    miniluz.selfhosting.backups.backups.actual =
      let
        extractionPath = "/tmp/actual-backup";
        filename = "actual.zip";
        secrets = config.age.secrets;
      in
      {
        paths = [ extractionPath ];
        # readWritePaths = [ extractionPath ];
        preHook = ''
          echo "Generating Actual data archive"
          echo "Setting extra certificate"
          export NODE_EXTRA_CA_CERTS=${host-secrets}/nebula.local.crt

          echo "Setting server URL"
          export SERVER_URL="https://actual.nebula.local"

          echo "Setting server password"
          export SERVER_PASSWORD=$(cat ${secrets.actual-password.path})

          echo "Setting sync ID"
          export SYNC_ID=$(cat ${secrets.actual-sync-id.path})

          echo "Adding bash to path"
          export PATH=${lib.makeBinPath [ pkgs.bash ]}:$PATH

          echo "Creating path to extract at"
          mkdir -p ${extractionPath}

          echo "Extracting"
          ${lib.getExe actual-backup} --sync-id "$SYNC_ID" --backup-dir "${extractionPath}" --backup-filename "${filename}"

          echo "Extracted to ${extractionPath}"
        '';
      };

    environment.systemPackages = [
      actual-backup
    ];

  };
}

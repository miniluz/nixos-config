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

  actual-backup = inputs.actual-backup.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  options.miniluz.selfhosting.actual = lib.mkEnableOption "Actual";

  config = lib.mkIf (cfg.enable && cfg.actual && cfg.server.enable) {

    assertions = [
      {
        assertion = pkgs.actual-server.version == actual-backup.version;
        message = "Mismatched versions for actual-server and actual-backup";
      }
    ];

    age.secrets.actual-sync-id.file = "${host-secrets}/actual-sync-id.age";
    age.secrets.actual-password.file = "${host-secrets}/actual-password.age";

    systemd.tmpfiles.rules = [
      "d ${dataDir} 0755 root root"
    ];

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
          echo "Setting server URL"
          export SERVER_URL="https://actual.home.miniluz.dev"

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

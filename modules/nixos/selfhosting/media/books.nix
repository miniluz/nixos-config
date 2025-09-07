{
  config,
  lib,
  pkgs,
  host-secrets,
  ...
}:
let
  cfg = config.miniluz.selfhosting;

  serverStorage = cfg.server.serverStorage;
  bookLibrary = "${serverStorage}/calibre-library";
  kavitaLibrary = "${serverStorage}/kavita-library";

  mediaGroup = config.util-nixarr.globals.libraryOwner.group;

  # bookshelf-src = pkgs.fetchFromGitHub {
  #   owner = "miniluz";
  #   repo = "bookshelf";
  #   rev = "develop";
  #   sha256 = "sha256-t/FuxEz9tmCVORfpoOnRboKM0dNAoFbjJ6KfXkWHeUQ=";
  # };
  # bookshelf = pkgs.readarr.overrideAttrs (_: {
  #   src = bookshelf-src;
  # });
in
{

  config = lib.mkIf (cfg.enable && cfg.jellyfin && cfg.server.enable) {

    age.secrets.kavita-token = {
      file = "${host-secrets}/kavita-token.age";
      mode = "700";
      owner = "kavita";
      group = "kavita";
    };

    users.users.kavita.extraGroups = [ mediaGroup ];
    users.users.calibre-server.extraGroups = [ mediaGroup ];
    users.users.calibre-web.extraGroups = [ mediaGroup ];

    systemd.tmpfiles.rules = [
      "d ${bookLibrary} 0750 calibre-server ${mediaGroup}"
      "d ${kavitaLibrary} 0750 kavita ${mediaGroup}"
    ];

    systemd.services.calibre-init = {
      description = "Initialize Calibre Library";
      wantedBy = [
        "calibre-server.service"
        "calibre-web.service"
      ];
      before = [
        "calibre-server.service"
        "calibre-web.service"
      ];
      requires = [ "systemd-tmpfiles-setup.service" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        User = "calibre-server";
        Group = mediaGroup;
      };

      script = ''
        set -euo pipefail  # Exit on any error

        LIBRARY_PATH="${bookLibrary}"

        echo "Checking Calibre library at: $LIBRARY_PATH"

        # Ensure parent directory exists and has correct permissions
        mkdir -p "$(dirname "$LIBRARY_PATH")"
        mkdir -p "$LIBRARY_PATH"

        # Check if library is already initialized
        if [ ! -f "$LIBRARY_PATH/metadata.db" ]; then
          echo "Initializing new Calibre library..."
          ${pkgs.calibre}/bin/calibredb --library-path="$LIBRARY_PATH" add --empty
          echo "Calibre library initialized successfully"
        else
          echo "Calibre library already exists"
        fi

        # Verify the library is valid
        ${pkgs.calibre}/bin/calibredb --library-path="$LIBRARY_PATH" list --limit=1 > /dev/null
        echo "Calibre library validation successful"
      '';
    };

    services.calibre-server = {
      enable = true;
      port = 9880;
      libraries = [ bookLibrary ];
      extraFlags = [ "--enable-local-write" ];
    };

    services.calibre-web = {
      enable = true;
      listen = {
        port = 9881;
        ip = "0.0.0.0";
      };
      options.calibreLibrary = bookLibrary;
    };

    services.kavita = {
      enable = true;
      dataDir = bookLibrary;
      tokenKeyFile = config.age.secrets.kavita-token.path;
      settings.Port = 9884;
    };

    nixarr = {
      readarr = {
        enable = true;
        # package = bookshelf;
      };

      readarr-audiobook = {
        enable = true;
        # package = bookshelf;
      };
    };

  };
}

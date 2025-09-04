{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.miniluz.selfhosting;
  redis-port = 32141;

  # Directory paths
  spotizerrStateDir = "${config.nixarr.stateDir}/spotizerr";
  musicLibraryDir = "${config.nixarr.mediaDir}/library/music";
  redisPasswordDir = "/var/lib/redis-spotizerr";
  redisPasswordFile = "${redisPasswordDir}/password";
  spotizerrEnvFile = "${spotizerrStateDir}/.env";
  spotizerrLogDir = "${spotizerrStateDir}/logs";
  spotizerrDataDir = "${spotizerrStateDir}/data";

  # User/group references
  mediaGroup = config.util-nixarr.globals.libraryOwner.group;
  spotizerrUid = 32141;
  mediaGid = config.util-nixarr.globals.gids.media;

in
{
  config = lib.mkIf (cfg.enable && cfg.jellyfin && cfg.server.enable && false) {
    assertions = [
      {
        assertion = config.nixarr.stateDir or null != null;
        message = "nixarr.stateDir must be configured for spotizerr";
      }
      {
        assertion = config.nixarr.mediaDir or null != null;
        message = "nixarr.mediaDir must be configured for spotizerr";
      }
      {
        assertion = mediaGroup != null;
        message = "util-nixarr.globals.libraryOwner.group must be configured for spotizerr";
      }
    ];

    users.users.spotizerr = {
      uid = spotizerrUid;
      group = "spotizerr";
      extraGroups = [ mediaGroup ];

      isSystemUser = true;

      home = spotizerrStateDir;
      createHome = true;
    };

    users.groups.spotizerr.gid = spotizerrUid;

    systemd.tmpfiles.rules = [
      "d ${musicLibraryDir} 0775 spotizerr ${mediaGroup} -"
      "d ${spotizerrLogDir} 0700 spotizerr spotizerr -"
      "d ${spotizerrDataDir} 0700 spotizerr spotizerr -"
      "d ${redisPasswordDir} 0750 redis-spotizerr redis-spotizerr -"
    ];

    systemd.services.spotizerr-password-generator = {
      description = "Generate Redis password for Spotizerr";
      wantedBy = [ "multi-user.target" ];
      before = [
        "redis-spotizerr.service"
        "quadlet-spotizerr-app.service"
      ];
      requires = [ "systemd-tmpfiles-setup.service" ];

      serviceConfig = {
        Type = "oneshot";
        User = "root";
        RemainAfterExit = true;
      };

      script = ''
                set -euo pipefail
                
                # Set secure file creation mask
                umask 077
                
                echo "Setting up Spotizerr Redis authentication..."
                
                # Generate password if it doesn't exist
                if [ ! -f "${redisPasswordFile}" ]; then
                  echo "Generating new Redis password..."
                  if ! ${pkgs.openssl}/bin/openssl rand -base64 32 > "${redisPasswordFile}"; then
                    echo "ERROR: Failed to generate Redis password" >&2
                    exit 1
                  fi
                  echo "Redis password generated successfully"
                else
                  echo "Redis password already exists, skipping generation"
                fi
                
                # Set secure permissions for Redis password file
                chown redis-spotizerr:redis-spotizerr "${redisPasswordFile}"
                chmod 400 "${redisPasswordFile}"
                
                # Create environment file for container
                echo "Creating Spotizerr environment file..."
                cat > "${spotizerrEnvFile}" << EOF
        REDIS_PASSWORD=$(cat "${redisPasswordFile}")
        EOF
                
                # Set secure permissions for environment file
                chown spotizerr:spotizerr "${spotizerrEnvFile}"
                chmod 600 "${spotizerrEnvFile}"
                
                echo "Spotizerr authentication setup completed"
      '';
    };

    services.redis.servers.spotizerr = {
      enable = true;
      port = redis-port;
      bind = "127.0.0.1";
      requirePassFile = redisPasswordFile;
    };

    # Ensure Redis waits for password generation
    systemd.services.redis-spotizerr = {
      requires = [ "spotizerr-password-generator.service" ];
      after = [ "spotizerr-password-generator.service" ];
    };

    virtualisation.quadlet.containers.spotizerr-app = {
      autoStart = true;

      containerConfig = {
        image = "docker.io/cooldockerizer93/spotizerr";
        publishPorts = [ "7171:7171" ];

        # needed to access redis on host
        networks = [ "host" ];

        environments = {
          HOST = "0.0.0.0";

          REDIS_HOST = "127.0.0.1";
          REDIS_PORT = toString redis-port;
          REDIS_DB = "0";

          PUID = toString spotizerrUid;
          PGID = toString mediaGid;
        };

        environmentFiles = [ spotizerrEnvFile ];

        volumes = [
          "${spotizerrDataDir}:/app/data"
          "${spotizerrLogDir}:/app/logs"

          "${musicLibraryDir}:/app/downloads"
        ];
      };

      serviceConfig = {
        Restart = "on-failure";
        RestartSec = "10";
      };

      unitConfig = {
        Requires = [
          "redis-spotizerr.service"
          "spotizerr-password-generator.service"
        ];
        After = [
          "redis-spotizerr.service"
          "spotizerr-password-generator.service"
        ];
      };
    };
  };
}

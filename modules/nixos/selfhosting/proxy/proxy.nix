{
  config,
  pkgs,
  lib,
  host-secrets,
  ...
}:
let
  cfg = config.miniluz.selfhosting;

  makeService = name: port: condition: {
    inherit name port condition;
  };

  baseUrl = "home.miniluz.dev";

  proxies = lib.filter ({ condition, ... }: condition) [
    # (makeService "syncthing" 8384 cfg.syncthing) DO NOT PROXY as it doesn't have a password
    # (makeService "samba" 8791 cfg.samba)
    (makeService "immich" 2283 cfg.immich)

    (makeService "actual" 9991 cfg.actual)

    (makeService "n8n" 5678 cfg.n8n)

    # --- Jellyfin ---
    (makeService "transmission" 9091 cfg.jellyfin)

    (makeService "jellyfin" 8096 cfg.jellyfin)
    (makeService "jellyseer" 5055 cfg.jellyfin)

    (makeService "prowlarr" 9696 cfg.jellyfin)

    (makeService "radarr" 7878 cfg.jellyfin)
    (makeService "sonarr" 8989 cfg.jellyfin)
    (makeService "bazarr" 6767 cfg.jellyfin)
    # (makeService "spotizerr" 7171 cfg.jellyfin)
    # (makeService "podgrab" 7171 cfg.jellyfin)

    # (makeService "calibre-server" 9880 cfg.jellyfin)
    # (makeService "calibre" 9881 cfg.jellyfin)
    # ----------------

    # (makeService "lidarr" 8686 cfg.jellyfin)
  ];

  homepage = import ./_homepage.nix {
    inherit
      pkgs
      lib
      baseUrl
      proxies
      ;
  };
in
{
  config = lib.mkIf (cfg.enable && cfg.server.enable) {

    programs.ssh.knownHosts."[u489829-sub1.your-storagebox.de]:23".publicKeyFile =
      "${host-secrets}/hetzner-public-keys.pub";

    age.secrets.hetzner-dns-api-key = {
      file = "${host-secrets}/hetzner-dns-api-key.age";
      mode = "600";
      owner = "acme";
      group = "acme";
    };

    services.dnsmasq = {
      enable = true;
      resolveLocalQueries = false;

      settings = {
        # Listen on all interfaces (or specify specific ones)

        # Don't read /etc/hosts
        no-hosts = true;
        no-poll = true;
        no-resolv = true;

        # Custom DNS entries
        address = [
          "/${baseUrl}/${cfg.server.address}"
        ]
        ++ (
          let
            makeSubdomain = { name, ... }: "/${name}.${baseUrl}/${cfg.server.address}";
          in
          lib.map makeSubdomain proxies
        );

        # server = [ "100.100.100.100" ];
      };
    };

    networking.firewall = {
      allowedTCPPorts = [
        80
        443
      ];

      interfaces."tailscale0" = {
        allowedUDPPorts = [ 53 ];
        allowedTCPPorts = [ 53 ];
      };
    };

    security.acme = {
      acceptTerms = true;
      defaults = {
        email = "javiermiladossantos@gmail.com";
        extraLegoFlags = [
          "--dns.resolvers"
          "8.8.8.8:53"
        ];
      };

      certs.${baseUrl} = {
        domain = "*.${baseUrl}";
        group = "nginx";
        dnsProvider = "hetzner";
        environmentFile = config.age.secrets.hetzner-dns-api-key.path;
      };
    };

    services.nginx = {
      enable = true;

      recommendedTlsSettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;

      virtualHosts = lib.mkMerge [
        (
          let
            makeVirtualHost =
              { name, port, ... }:
              {
                name = "${name}.${baseUrl}";
                value = {
                  useACMEHost = baseUrl;
                  forceSSL = true;

                  # extraConfig = ''
                  #   ssl_stapling off;
                  #   ssl_stapling_verify off;
                  # '';

                  locations."/" = {
                    recommendedProxySettings = true;
                    proxyWebsockets = true;
                    proxyPass = "http://127.0.0.1:${builtins.toString port}";
                  };
                };
              };
          in
          lib.pipe proxies [
            (lib.map makeVirtualHost)
            lib.listToAttrs
          ]
        )
        {
          "${baseUrl}" = {
            serverAliases = [ "www.${baseUrl}" ];

            useACMEHost = baseUrl;
            forceSSL = true;

            root = homepage;
            locations."/" = {
              index = "index.html";
            };

          };
        }
      ];
    };
  };
}

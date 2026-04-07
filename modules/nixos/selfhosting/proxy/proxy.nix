{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.miniluz.selfhosting;
  inherit (config.miniluz.constants) host-secrets;

  makeService = name: port: condition: {
    inherit name port condition;
  };

  baseUrl = "home.miniluz.dev";

  proxies = lib.filter ({ condition, ... }: condition) [
    (makeService "btop" 7861 true)
    (makeService "searxng" 7881 cfg.searxng)
    (makeService "rss" 7882 cfg.rss)
    # (makeService "syncthing" 8384 cfg.syncthing) DO NOT PROXY as it doesn't have a password
    # (makeService "samba" 8791 cfg.samba)
    (makeService "immich" 2283 cfg.immich)

    (makeService "actual" 9991 cfg.actual)

    (makeService "librechat" 3080 cfg.librechat)
    (makeService "n8n" 5678 cfg.n8n)

    # --- Jellyfin ---
    (makeService "transmission" 9091 cfg.jellyfin)

    (makeService "jellyfin" 8096 cfg.jellyfin)
    (makeService "audiobookshelf" 9292 cfg.jellyfin)
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

    age.secrets.hetzner-dns-api-key = {
      file = "${host-secrets}/hetzner-dns-api-key.age";
      mode = "600";
      owner = "acme";
      group = "acme";
    };

    # This DNS exclusively resolves the domains.
    # It's not meant to be a DNS replacement, just to resolve my subdomains
    services.dnsmasq = {
      enable = true;
      resolveLocalQueries = false;

      settings = {
        interface = "tailscale0";
        bind-interfaces = true;

        # Don't read /etc/hosts
        no-hosts = true;
        no-poll = true;
        no-resolv = true;

        # Custom DNS entries
        address =
          let
            makeSubdomain = { name, ... }: "/${name}.${baseUrl}/${cfg.server.address}";
          in
          (
            [
              "/${baseUrl}/${cfg.server.address}"
              "/nextcloud.${baseUrl}/${cfg.server.address}"
            ]
            ++ (lib.map makeSubdomain proxies)

          );
      };
    };

    systemd.services.dnsmasq.after = [ "tailscaled.service" ];

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
          "9.9.9.9:53"
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

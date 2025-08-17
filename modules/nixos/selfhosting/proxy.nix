{
  config,
  lib,
  host-secrets,
  ...
}:
let
  cfg = config.miniluz.selfhosting;

  makeService = name: port: condition: {
    inherit port condition;
    name = "${name}.${hostname}";
  };

  hostname = "nebula.local";

  proxies = lib.filter ({ condition, ... }: condition) [
    # (makeService "syncthing" 8384 cfg.syncthing) DO NOT PROXY as it doesn't have a password
    (makeService "immich" 2283 cfg.immich)

    (makeService "actual" 9991 cfg.actual)

    # --- Jellyfin ---
    (makeService "transmission" 9091 cfg.jellyfin)

    (makeService "jellyfin" 8096 cfg.jellyfin)
    (makeService "audiobookshelf" 9292 cfg.jellyfin)

    (makeService "jellyseer" 5055 cfg.jellyfin)

    (makeService "prowlarr" 9696 cfg.jellyfin)

    (makeService "radarr" 7878 cfg.jellyfin)
    (makeService "sonarr" 8989 cfg.jellyfin)
    (makeService "bazarr" 6767 cfg.jellyfin)
    (makeService "spotizerr" 7171 cfg.jellyfin)
    (makeService "podgrab" 4242 cfg.jellyfin)

    (makeService "readarr" 8787 cfg.jellyfin)
    (makeService "readarr-audiobook" 9494 cfg.jellyfin)
    (makeService "calibre-server" 9880 cfg.jellyfin)
    (makeService "calibre" 9881 cfg.jellyfin)
    # ----------------

    # (makeService "lidarr" 8686 cfg.jellyfin)
  ];

  domains = [ hostname ] ++ (map ({ name, ... }: name) proxies);
in
{
  config = lib.mkIf (cfg.enable && cfg.server.enable) {

    age.secrets."nebula.local.key" = {
      file = "${host-secrets}/nebula.local.key.age";
      mode = "600";
      owner = "nginx";
      group = "nginx";
    };

    services.dnsmasq = {
      enable = true;
      resolveLocalQueries = false;

      settings = {
        # Listen on all interfaces (or specify specific ones)
        interface = "tailscale0";

        # Don't read /etc/hosts
        no-hosts = true;
        no-poll = true;
        no-resolv = true;

        # Custom DNS entries
        address =
          let
            makeSubdomain = name: "/${name}/${cfg.server.address}";
          in
          lib.map makeSubdomain domains;

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

    # security.acme = {
    #   acceptTerms = true;
    #   defaults.email = "javiermiladossantos@gmail.com";
    # };

    services.nginx = {
      enable = true;

      recommendedTlsSettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;

      virtualHosts =
        let
          sslCertificate = "${host-secrets}/nebula.local.crt";
          sslCertificateKey = config.age.secrets."nebula.local.key".path;

          makeVirtualHost =
            { name, port, ... }:
            {
              inherit name;
              value = {
                inherit sslCertificate sslCertificateKey;
                forceSSL = true;

                extraConfig = ''
                  ssl_stapling off;
                  ssl_stapling_verify off;
                '';

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
        ];
    };

  };
}

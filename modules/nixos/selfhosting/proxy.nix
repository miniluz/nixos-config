{
  config,
  lib,
  ...
}:
let
  cfg = config.miniluz.selfhosting;

  makeService = name: port: condition: {
    inherit port condition;
    name = "${name}.${hostname}";
  };

  hostname = "home-server.snowy-trench.ts.net";

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
    (makeService "podgrab" 7171 cfg.jellyfin)

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

    services.caddy = {
      enable = true;

      virtualHosts =
        let
          makeVirtualHost =
            { name, port, ... }:
            {
              inherit name;
              value = {
                listenAddresses = [ "127.0.0.1:${builtins.toString port}" ];
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

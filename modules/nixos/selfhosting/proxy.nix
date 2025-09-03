{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.miniluz.selfhosting;

  makeService = name: port: condition: {
    inherit name port condition;
  };

  tailscaleHost = "home-server.snowy-trench.ts.net";
  baseUrl = "nebula.local";

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
in
{
  config = lib.mkIf (cfg.enable && cfg.server.enable) {

    services.knot = {
      enable = true;
      settings = {
        server = {
          listen = [
            "0.0.0.0@53"
            "::@53"
          ];
        };
        zone = [
          {
            domain = baseUrl;
            file =
              let
                # makeCnameRecord = { name, ... }: "${name} IN CNAME ${tailscaleHost}.";
                makeCnameRecord = { name, ... }: "${name} IN A ${cfg.server.address}";
                zoneFileContent = ''
                  $TTL 3600
                  $ORIGIN ${baseUrl}.

                  ; SOA Record
                  @ IN SOA ns1.${baseUrl}. admin.${baseUrl}. (
                      2025080301 ; serial (YYYYMMDDNN)
                      3600       ; refresh (1 hour)
                      1800       ; retry (30 minutes)  
                      1209600    ; expire (2 weeks)
                      3600       ; minimum TTL (1 hour)
                  )

                  ; Name Server Record
                  @ IN NS ns1.${baseUrl}.

                  ; A Record for the name server
                  ns1 IN A ${cfg.server.address}

                  ; Root domain A record
                  @ IN A ${cfg.server.address}

                  ; CNAME Records for subdomains
                  ${lib.concatStringsSep "\n" (lib.map makeCnameRecord proxies)}
                '';
              in
              pkgs.writeTextFile {
                name = "nebula.local.zone";
                text = zoneFileContent;
              };
          }
        ];
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
      enableReload = false;

      globalConfig = ''
        auto_https off
      '';

      virtualHosts.${tailscaleHost} = {
        serverAliases = lib.map (proxy: "${proxy.name}.${baseUrl}") proxies;
        extraConfig = ''
          tls {
            get_certificate tailscale
          }

          # Route based on the Host header
          ${lib.concatStringsSep "\n" (
            lib.map (proxy: ''
              @${proxy.name} host ${proxy.name}.${baseUrl}
              handle @${proxy.name} {
                reverse_proxy 127.0.0.1:${builtins.toString proxy.port}
              }
            '') proxies
          )}

          # Default handler for direct access to tailscale hostname
          handle {
            respond "Available services: ${
              lib.concatStringsSep ", " (lib.map (p: "${p.name}.${baseUrl}") proxies)
            }" 200
          }
        '';
      };
    };
  };
}

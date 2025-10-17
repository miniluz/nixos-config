{
  config,
  lib,
  host-secrets,
  ...
}:
let
  cfg = config.miniluz.selfhosting;
  serverStorage = config.miniluz.selfhosting.server.serverStorage;
  mediaDir = "${serverStorage}/jellyfin-media";
  stateDir = "${serverStorage}/jellyfin-state";
in
{
  options.miniluz.selfhosting.jellyfin = lib.mkEnableOption "Jellyfin";

  config = lib.mkIf (cfg.enable && cfg.jellyfin && cfg.server.enable) {
    age.secrets.w0-conf = {
      file = "${host-secrets}/w0conf.age";
    };

    nixarr = {
      enable = true;

      inherit mediaDir stateDir;

      vpn = {
        enable = true;
        accessibleFrom = [
          "192.168.50.0/24"
          "100.64.0.0/10"
        ];
        vpnTestService.enable = true;

        wgConf = config.age.secrets.w0-conf.path;
      };

      jellyfin.enable = true;
      audiobookshelf.enable = true;

      jellyseerr.enable = true;

      transmission = {
        enable = true;
        vpn.enable = true;
        extraAllowedIps = [
          "100.64.0.0/10"
        ];
        peerPort = 12543; # Set this to the port forwarded by your VPN

        extraSettings = {
          "speed-limit-down" = 3000;
          "speed-limit-down-enabled" = true;
          "speed-limit-up" = 1000;
          "speed-limit-up-enabled" = true;
        };

        # flood.enable = true;
      };

      # It is possible for this module to run the *Arrs through a VPN, but it
      # is generally not recommended, as it can cause rate-limiting issues.
      # autobrr.enable = true;
      bazarr.enable = true; # subtitles
      # lidarr.enable = true; # music
      radarr.enable = true; # movies
      sonarr.enable = true; # tv shows

      prowlarr = {
        enable = true; # index manager
        vpn.enable = true;
      };

      # recyclarr.enable = true; # media naming for sonarr and radarr
    };

    services.transmission.settings.rpc-host-whitelist = "transmission.nebula.local";

  };
}

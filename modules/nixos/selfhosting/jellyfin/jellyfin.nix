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

  podgrabDir = "${mediaDir}/library/podcasts";
  podgrabPort = 4242;
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

        wgConf = config.age.secrets.w0-conf.path;

        accessibleFrom = [ "192.168.50.0/24" ];
      };

      jellyfin.enable = true;
      audiobookshelf.enable = true;

      jellyseerr.enable = true;

      transmission = {
        enable = true;
        vpn.enable = true;
        # peerPort = 50000; # Set this to the port forwarded by your VPN

        flood.enable = true;
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

    };

    services.podgrab = {
      enable = true;
      port = podgrabPort;
      dataDirectory = podgrabDir;
    };

    services.flaresolverr.enable = true;

  };
}

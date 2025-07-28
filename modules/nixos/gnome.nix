{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.miniluz.gnome;
in
{
  options.miniluz.gnome.enable = lib.mkEnableOption "Enable GNOME and GDM";

  config = lib.mkIf cfg.enable {
    services.xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager = {
        gnome.enable = true;
        xterm.enable = false;
      };
    };

    # services.gnome.gcr-ssh-agent.enable = false;

    environment.gnome.excludePackages = (
      with pkgs;
      [
        cheese # webcam tool
        epiphany # web browser
        geary # email reader
        evince # document viewer
        totem # video player
        # gnome-photos
        gnome-tour
        gedit # text editor
        gnome-music
        gnome-characters
        tali # poker game
        iagno # go game
        hitori # sudoku game
        atomix # puzzle game
        gnome-weather
        gnome-connections
        snapshot
        yelp
        gnome-maps
      ]
    );

    environment.systemPackages =
      with pkgs;
      [
        xwayland-run
      ]
      ++ (with pkgs.gnomeExtensions; [
        appindicator
        blur-my-shell
        just-perfection
        fuzzy-app-search
        clipboard-indicator
        forge
        user-themes
      ]);

    services.udev.packages = [ pkgs.gnome-settings-daemon ];

  };
}

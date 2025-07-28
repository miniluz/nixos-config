{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.miniluz.gnome;
  gnome-extensions = with pkgs; [
    appindicator
    blur-my-shell
    just-perfection
    fuzzy-app-search
    clipboard-indicator
    forge
    user-themes
  ];
in
{
  imports = [ (lib.mkAliasOptionModule [ "hm" ] [ "home-manager" "users" "miniluz" ]) ];

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

    hm = {
      dconf = {
        enable = true;
        settings = {
          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
            enable-hot-corners = false;
          };

          "org/gnome/desktop/peripherals/touchpad" = {
            click-method = "areas";
            tap-to-click = true;
            two-finger-scrolling-enabled = true;
          };

          "org/gnome/settings-daemon/plugins/power" = {
            power-button-action = "nothing";
            sleep-inactive-ac-type = "nothing";
            sleep-inactive-battery-type = "nothing";
          };
          "org/gnome/shell".enabled-extensions = map (extension: extension.extensionUuid) gnome-extensions;
        };
      };
    };

    environment.systemPackages =
      with pkgs;
      [
        dconf2nix
        gnome-tweaks
        xwayland-run
      ]
      ++ gnome-extensions;

    services.udev.packages = [ pkgs.gnome-settings-daemon ];

  };
}

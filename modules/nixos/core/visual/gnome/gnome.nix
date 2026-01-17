{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.miniluz.gnome;
  gnome-extensions = with pkgs.gnomeExtensions; [
    appindicator
    blur-my-shell
    just-perfection
    fuzzy-app-search
    clipboard-indicator
    forge
    user-themes
    hide-top-bar
  ];
in
{
  options.miniluz.gnome.enable = lib.mkEnableOption "Enable GNOME and GDM";

  config = lib.mkIf cfg.enable {
    services = {
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };

    # services.gnome.gcr-ssh-agent.enable = false;

    environment.gnome.excludePackages = with pkgs; [
      gnome-tour
      gnome-maps
    ];

    programs = {
      ssh.startAgent = false;
      dconf.profiles.user.databases = [
        {
          # lockAll = true;
          settings = {
            "org/gnome/desktop/interface" = {
              color-scheme = "prefer-dark";
              enable-hot-corners = false;
            };

            "org/gnome/desktop/wm/preferences".focus-new-windows = "smart";

            "org/gnome/desktop/wm/keybindings" = {
              switch-windows = [ "<Alt>Tab" ];
              switch-windows-backward = [ "<Shift><Alt>Tab" ];

              switch-applications = [ "<Super>Tab" ];
              switch-applications-backward = [ "<Shift><Super>Tab" ];
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

            "org/gnome/settings-daemon/plugins/color" = {
              night-light-enabled = true;
              night-light-schedule-from = 22.0;
              night-light-schedule-to = 23.983333333333331;
              night-light-temperature = lib.gvariant.mkUint32 1700;
            };

            # TODO: make this extensible
            "org/gnome/settings-daemon/plugins/media-keys" = {
              "custom-keybindings" = [
                "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
              ];
            };

            "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
              binding = "<Super>q";
              command = "ghostty";
              name = "Open terminal";
            };

            "org/gnome/shell" = {
              enabled-extensions = map (extension: extension.extensionUuid) gnome-extensions;
              disable-user-extensions = false;
            };

            # Extension settings

            "org/gnome/shell/extensions/blur-my-shell/panel" = {
              blur = false;
            };
          };
        }
      ];
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

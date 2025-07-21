{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.miniluz.gnome;
in
{
  imports = [
    ./catppuccin.nix
    ./backgrounds.nix
  ];

  options.miniluz.gnome.enable = lib.mkEnableOption "Enable GNOME config.";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.gnome-tweaks
      pkgs.dconf2nix
    ];

    dconf.settings = {
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
    };
  };
}

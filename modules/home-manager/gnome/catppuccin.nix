{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.miniluz.gnome.catppuccin;
in
{
  options.miniluz.gnome.catppuccin.enable = lib.mkEnableOption "Enable GNOME's Catppuccin theme";

  config = lib.mkIf cfg.enable {
    gtk = {
      enable = true;
      theme = {
        name = "Catppuccin-Macchiato-Compact-Pink-Dark";
        package = pkgs.catppuccin-gtk.override {
          accents = [ "pink" ];
          size = "compact";
          tweaks = [
            "rimless"
            "black"
          ];
          variant = "macchiato";
        };
      };
    };

    # Now symlink the `~/.config/gtk-4.0/` folder declaratively:
    xdg.configFile = {
      "gtk-4.0/assets".source =
        "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
      "gtk-4.0/gtk.css".source =
        "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
      "gtk-4.0/gtk-dark.css".source =
        "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
    };
  };
}

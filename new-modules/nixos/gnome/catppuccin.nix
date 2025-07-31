{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.miniluz.gnome;
in
{
  options.miniluz.gnome.catppuccin = lib.mkOption {
    default = true;
    description = "Whether to use the Catppuccin theme for GNOME";
  };

  config.hm = lib.mkIf (cfg.enable && cfg.catppuccin) {
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
    xdg.configFile =
      let
        gtk-theme = config.hm.gtk.theme;
      in
      {
        "gtk-4.0/assets".source = "${gtk-theme.package}/share/themes/${gtk-theme.name}/gtk-4.0/assets";
        "gtk-4.0/gtk.css".source = "${gtk-theme.package}/share/themes/${gtk-theme.name}/gtk-4.0/gtk.css";
        "gtk-4.0/gtk-dark.css".source =
          "${gtk-theme.package}/share/themes/${gtk-theme.name}/gtk-4.0/gtk-dark.css";
      };
  };
}

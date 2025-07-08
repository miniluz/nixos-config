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
  options.miniluz.gnome.enable = lib.mkEnableOption "Enable GNOME and GDE";

  config = lib.mkIf cfg.enable {
    services.xserver.enable = true;
    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;

    services.gnome.gcr-ssh-agent.enable = false;

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
      ]
    );

    environment.systemPackages = with pkgs; [
      xwayland-run
    ];
  };
}

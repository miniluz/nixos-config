{
  config,
  lib,
  ...
}:
let
  cfg = config.miniluz.niri;
  inherit (config.miniluz.constants) miniluz-pkgs;
in
{
  options.miniluz.niri.enable = lib.mkEnableOption "Enable Niri";

  config = lib.mkIf cfg.enable {
    services = {
      displayManager.gdm.enable = true;
    };

    programs.niri = {
      enable = true;
      package = miniluz-pkgs.niri-luzwrap;
    };

    security.polkit.enable = true; # polkit
    services.gnome.gnome-keyring.enable = true; # secret service
    security.pam.services.swaylock = { };

    environment.systemPackages = [
      miniluz-pkgs.niri-luzwrap
    ];

  };
}

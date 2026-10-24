{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.miniluz.gaming;
in
{
  options.miniluz.gaming.enable = lib.mkEnableOption "Enable Gaming.";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      qbittorrent

      # itch

      winetricks
      mangohud
    ];

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      extest.enable = true;
      extraCompatPackages = [
        pkgs.proton-ge-bin
      ];
      gamescopeSession.enable = true;
      protontricks.enable = true;
    };

    programs.gamemode.enable = true;

    services.udev.extraRules = ''
      # Disable DS4 touchpad acting as mouse
      # USB
      ATTRS{name}=="Sony Interactive Entertainment Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
      # Bluetooth
      ATTRS{name}=="Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
    '';
  };
}

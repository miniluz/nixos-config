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
      # itch

      winetricks
      protontricks
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
    };

    programs.gamemode.enable = true;
  };
}

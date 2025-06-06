{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.miniluz.steam;
in
{
  options.miniluz.steam.enable = lib.mkEnableOption "Enable Steam.";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      protontricks
      mangohud
      gamemode
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

  };
}

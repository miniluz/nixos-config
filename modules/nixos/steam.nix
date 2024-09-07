{ config, pkgs, lib, ... }:
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
      gnomeExtensions.gamemode-indicator-in-system-settings
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

    # environment.systemPackages = with pkgs; [
    #   (steam.override {
    #     extraPkgs = pkgs: [ mono gtk3 gtk3-x11 libgdiplus zlib ];
    #     nativeOnly = true;
    #   }).run
    #   (steam.override {
    #     withPrimus = true;
    #     extraPkgs = pkgs: [ bumblebee glxinfo ];
    #     nativeOnly = true;
    #   }).run
    #   (steam.override { withJava = true; })
    # ];
  };
}

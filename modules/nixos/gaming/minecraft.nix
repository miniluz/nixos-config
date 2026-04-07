{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.miniluz.gaming.minecraft;
  inherit (config.miniluz.constants) miniluz-pkgs;
in
{
  options.miniluz.gaming.minecraft = lib.mkEnableOption "Enable Minecraft.";

  config = lib.mkIf cfg {
    networking.firewall = {
      allowedTCPPorts = [ 25565 ];
      allowedUDPPorts = [ 25565 ];
    };

    users.users.miniluz.packages = with pkgs; [
      prismlauncher
      temurin-jre-bin
      miniluz-pkgs.playit-agent
    ];
  };
}

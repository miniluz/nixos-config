{
  config,
  lib,
  pkgs,
  global-secrets,
  inputs,
  ...
}:
let
  cfg = config.miniluz.gaming.minecraft;
in
{
  imports = [
    inputs.playit-nixos-module.nixosModules.default
  ];

  options.miniluz.gaming.minecraft = lib.mkEnableOption "Enable Minecraft.";

  config = lib.mkIf cfg {
    age.secrets.playit = {
      file = "${global-secrets}/playit.age";
      mode = "444";
    };

    services.playit = {
      enable = true;
      secretPath = config.age.secrets.playit.path;
    };

    systemd.services.playit.wantedBy = lib.mkForce [ ];

    networking.firewall = {
      allowedTCPPorts = [ 25565 ];
      allowedUDPPorts = [ 25565 ];
    };

    users.users.miniluz.packages = with pkgs; [
      prismlauncher
      temurin-jre-bin
    ];
  };
}

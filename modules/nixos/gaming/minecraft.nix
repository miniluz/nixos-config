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
      owner = "playit";
    };

    services.playit = {
      enable = true;
      user = "playit";
      group = "playit";
      secretPath = config.age.secrets.playit.path;
    };

    systemd.services.playit.wantedBy = lib.mkForce [ ];

    hm = {
      fonts.fontconfig.enable = true;

      home.packages = with pkgs; [
        prismlauncher
        temurin-jre-bin
      ];
    };
  };
}

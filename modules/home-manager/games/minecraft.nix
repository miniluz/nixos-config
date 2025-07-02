{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.miniluz.games.minecraft;
in
{
  options.miniluz.games.minecraft.enable = lib.mkEnableOption "Enable Minecraft.";

  config = lib.mkIf cfg.enable {
    fonts.fontconfig.enable = true;

    home.packages = with pkgs; [
      prismlauncher
      temurin-jre-bin
    ];
  };
}

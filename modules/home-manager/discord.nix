{ config, pkgs, lib, ... }:
let
  cfg = config.miniluz.discord;
in
{
  options.miniluz.discord.enable = lib.mkEnableOption "Enable Discord.";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      (discord.override {
        withOpenASAR = true;
        withVencord = true;
      })
    ];
 };
}

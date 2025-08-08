{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.miniluz.social;
in
{
  options.miniluz.social.enable = lib.mkEnableOption "Enable Discord.";

  config.hm = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      (discord.override {
        # withOpenASAR = true;
        withVencord = true;
      })

      element-desktop
    ];
  };
}

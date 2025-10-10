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

  config = lib.mkIf cfg.enable {
    users.users.miniluz.packages = with pkgs; [
      (discord.override {
        # withOpenASAR = true;
        withVencord = true;
      })

      element-desktop
    ];
  };
}

{ config, lib, ... }:
let
  cfg = config.miniluz.git;
in
{
  options.miniluz.git.enable = lib.mkEnableOption "Enable configured git.";

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = "miniluz";
      userEmail = "javiermelon4fu@gmail.com";
      extraConfig = {
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
      };
    };
  };
}

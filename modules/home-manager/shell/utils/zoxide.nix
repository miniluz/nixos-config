{ config, pkgs, lib, ... }:
let
  cfg = config.miniluz.zoxide;
in
{
  imports = [ ../fish.nix ];

  options.miniluz.zoxide.enable = lib.mkEnableOption "Enable ZOxide.";

  config = lib.mkIf cfg.enable {
    programs.zoxide = {
      enable = true;
    }
    // (if config.miniluz.fish.enable then { enableFishIntegration = true; } else { });

    programs.zsh.envExtra = ''alias cd="z"'';

    programs.fish.shellAliases.cd = "z";
  };
}

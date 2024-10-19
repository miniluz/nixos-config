# Don't forget to add
# environment.pathsToLink = [ "/share/zsh" ];
# to the system configuration.
{ pkgs, lib, config, ... }:
let
  cfg = config.miniluz.zsh;
in
{
  options.miniluz.zsh = {
    enable = lib.mkEnableOption "Enable miniluz's zsh.";
  };

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      plugins = with pkgs; [
        {
          name = "zsh-nix-shell";
          src = "${zsh-nix-shell}/share/zsh-nix-shell";
        }
      ];
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      enableCompletion = true;

      history.ignoreAllDups = true;
    };
  };
}

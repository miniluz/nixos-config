# Don't forget to add
# environment.pathsToLink = [ "/share/zsh" ];
# to the system configuration.
{ pkgs, lib, config, ... }:
let
  cfg = config.miniluz.zsh;
  zsh-nix-shell = {
    name = "zsh-nix-shell";
    file = "nix-shell.plugin.zsh";
    src = pkgs.fetchFromGitHub {
      owner = "chisui";
      repo = "zsh-nix-shell";
      rev = "v0.8.0";
      sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
    };
  };
in
{
  options.miniluz.zsh = {
    enable = lib.mkEnableOption "Enable miniluz's zsh with Starship.";
  };

  config = lib.mkIf cfg.enable {
    programs.zsh.enable = true;
    programs.zsh.plugins = [ zsh-nix-shell ];
    programs.zsh.enableCompletion = true;
    programs.zsh.oh-my-zsh = {
      enable = true;
      # TODO: fix me!
      plugins = if config.miniluz.starship.enable then [ "starship" ] else [];
    };
  };
}

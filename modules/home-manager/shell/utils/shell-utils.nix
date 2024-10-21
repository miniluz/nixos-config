{ pkgs, lib, config, ... }:
let
  cfg = config.miniluz.shell-utils;
in
{
  imports = [
    ./btop.nix
    ./eza.nix
    ./tldr.nix
    ./zoxide.nix
  ];

  options.miniluz.shell-utils = {
    enable = lib.mkEnableOption "Enable miniluz's shell utils.";
  };

  config = lib.mkIf cfg.enable {
    miniluz.btop.enable = lib.mkDefault true;
    miniluz.eza.enable = lib.mkDefault true;
    miniluz.tldr.enable = lib.mkDefault true;
    miniluz.zoxide.enable = lib.mkDefault true;
  };
}

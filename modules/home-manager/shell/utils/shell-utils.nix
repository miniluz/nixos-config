{
  pkgs,
  lib,
  config,
  ...
}:
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

    programs.bat.enable = lib.mkDefault true;
    programs.fd.enable = lib.mkDefault true;
    # yazi file manager

    programs.zellij = {
      enable = lib.mkDefault true;
      enableFishIntegration = lib.mkDefault true;
      settings = {
        on_force_close = "quit";
        show_startup_tips = false;
      };
    };

    home.packages = with pkgs; [
      dust
      ripgrep
      ripgrep-all
      wiki-tui
      kondo
      p7zip
      uutils-coreutils-noprefix
      hyperfine
      delta
    ];
  };
}

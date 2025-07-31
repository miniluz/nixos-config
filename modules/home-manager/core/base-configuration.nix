{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
let
  cfg = config;
in
{
  imports = [
    inputs.agenix.homeManagerModules.default
  ];

  options.miniluz.visual = lib.mkOption {
    default = true;
    description = "Wether to enable base configuration for visual systems.";
  };

  config = {
    home.username = "miniluz";
    home.homeDirectory = "/home/miniluz";

    home.packages =
      with pkgs;
      [
        inputs.agenix.packages."x86_64-linux".default
        miniluz.luznix-shell-setup
        miniluz.bg-run
        trashy
      ]
      ++ (if cfg.miniluz.visual then (with pkgs; [ vlc ]) else [ ]);

    programs.command-not-found.enable = false;
    programs.nix-index.enable = true;

    age.identityPaths = [ "/home/miniluz/.ssh/id_ed25519" ];

  };
}

{
  pkgs,
  inputs,
  lib,
  config,
  ...
}:
let
  cfg = config.miniluz.base_configuration;
in
{
  imports = [
    inputs.agenix.homeManagerModules.default
  ];

  options.miniluz.base_configuration.visual = lib.mkOption {
    default = true;
    example = false;
    description = "Wether to enable base configuration for visual systems.";
    type = lib.types.bool;
  };

  config = {

    home.packages =
      with pkgs;
      [
        inputs.agenix.packages."x86_64-linux".default
        miniluz.luznix-shell-setup
        miniluz.bg-run
        trashy
        vlc
      ]
      ++ (if cfg.visual then (with pkgs; [ vlc ]) else [ ]);

    programs.command-not-found.enable = false;
    programs.nix-index.enable = true;

    age.identityPaths = [ "/home/miniluz/.ssh/id_ed25519" ];

  };
}

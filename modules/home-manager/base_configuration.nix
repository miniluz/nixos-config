{
  pkgs,
  inputs,
  paths,
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
        (import "${paths.derivations}/nix-shell-setup.nix" { inherit pkgs; })
        (import "${paths.derivations}/bg-run.nix" { inherit pkgs; })
        trashy
        vlc
      ]
      ++ (if cfg.visual then (with pkgs; [ vlc ]) else [ ]);

    programs.command-not-found.enable = false;
    programs.nix-index.enable = true;

    age.identityPaths = [ "/home/miniluz/.ssh/id_ed25519" ];

    xdg.desktopEntries = lib.mkIf cfg.visual {
      "Rebuild" = {
        name = "Rebuild";
        genericName = "Rebuild NixOS";
        exec = ''bash -c "rebuild ; echo \\"Press enter to close this window...\\" ; read ans" '';
        terminal = true;
        icon = "utilities-terminal";
      };
    };
  };
}

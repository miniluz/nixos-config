# Configuration common to all computers
{
  inputs,
  pkgs,
  miniluz-pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkDefault;
  cfg = config;
in
{
  imports = [
    inputs.agenix.nixosModules.default
  ];

  options.miniluz.visual = lib.mkOption {
    default = true;
    description = "Enable options for visual systems";
  };

  config = {
    hm.miniluz.visual = cfg.miniluz.visual;

    age.identityPaths = [ "/home/miniluz/.ssh/id_ed25519" ];

    # Set timezone
    time.timeZone = mkDefault "Europe/Madrid";

    # Set keyboard layout for console and xserver
    services.xserver.xkb = mkDefault {
      layout = "es";
      variant = "";
    };
    console.keyMap = mkDefault "es";

    # My user
    users.users.miniluz = {
      isNormalUser = true;
      description = "miniluz";
      extraGroups = [
        "networkmanager"
        "wheel"
        "libvirtd"
      ];
    };

    networking.networkmanager.enable = mkDefault true;

    environment.systemPackages =
      with pkgs;
      [
        steam-run
        file
        uutils-coreutils-noprefix
        p7zip
        fd
        evil-helix
        nh
        nixfmt-rfc-style
        nil
        nushell
      ]
      ++ (with miniluz-pkgs; [
        font-cache-update
        luznix-rebuild
      ]);

    environment.sessionVariables = {
      EDITOR = "hx";
      NH_FLAKE = "/home/miniluz/nixos-config";
    };

    programs.command-not-found.enable = mkDefault false;
    programs.ssh.startAgent = mkDefault true;
    programs.nix-ld.enable = mkDefault true;

    nixpkgs.overlays = [
      inputs.nix-vscode-extensions.overlays.default
    ];

    documentation.man.generateCaches = false;
    hm.programs.man.generateCaches = false;
    documentation.nixos.enable = false;

  };
}

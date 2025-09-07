# Configuration common to all computers
{
  inputs,
  pkgs,
  miniluz-pkgs,
  lib,
  config,
  global-secrets,
  ...
}:
let
  inherit (lib) mkDefault;
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
    hm.miniluz.visual = config.miniluz.visual;

    age.identityPaths = [ "/home/miniluz/.ssh/id_ed25519" ];

    zramSwap.enable = mkDefault true;

    nix.optimise.automatic = mkDefault true;

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
      openssh.authorizedKeys.keyFiles = [ "${global-secrets}/miniluz.pub" ];
    };

    services = {
      openssh = {
        enable = true;
        settings.PasswordAuthentication = false;
      };
      fail2ban.enable = true;
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
        nmap
        dig.dnsutils
        bat
        ripgrep
        eza
      ]
      ++ (with miniluz-pkgs; [
        font-cache-update
        luznix-rebuild
        luznix-os-switch
        git-randomize-commit-times
      ]);

    environment.sessionVariables = {
      EDITOR = "hx";
      NH_FLAKE = "/home/miniluz/nixos-config";
    };

    programs = {
      nh = {
        enable = true;
        clean = {
          enable = true;
          extraArgs = "--keep 5 --keep-since 7d";
        };
      };
      command-not-found.enable = mkDefault false;
      ssh.startAgent = mkDefault true;
      nix-ld.enable = mkDefault true;
    };

    documentation.man.generateCaches = false;
    hm.programs.man.generateCaches = false;
    documentation.nixos.enable = false;

  };
}

# Configuration common to all computers
{
  inputs,
  pkgs,
  lib,
  paths,
  ...
}:
let
  mkDefault = lib.mkDefault;
in
{
  imports = [
    inputs.agenix.nixosModules.default
  ];

  age.identityPaths = [ "/home/miniluz/.ssh/id_ed25519" ];

  # Enable flakes
  nix.settings.experimental-features = mkDefault [
    "nix-command"
    "flakes"
  ];

  # Set timezone
  time.timeZone = mkDefault "Europe/Madrid";

  # Set locales
  i18n.defaultLocale = mkDefault "en_US.UTF-8";
  i18n.extraLocaleSettings = mkDefault {
    LC_ADDRESS = "es_ES.UTF-8";
    LC_IDENTIFICATION = "es_ES.UTF-8";
    LC_MEASUREMENT = "es_ES.UTF-8";
    LC_MONETARY = "es_ES.UTF-8";
    LC_NAME = "es_ES.UTF-8";
    LC_NUMERIC = "es_ES.UTF-8";
    LC_PAPER = "es_ES.UTF-8";
    LC_TELEPHONE = "es_ES.UTF-8";
    LC_TIME = "es_ES.UTF-8";
  };

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

  environment.systemPackages = with pkgs; [
    file
    nixfmt-rfc-style
    uutils-coreutils-noprefix
    p7zip
    fd
    evil-helix
    nh
    nil
    (import "${paths.derivations}/rebuild.nix" { inherit pkgs; })
    (import "${paths.derivations}/font-cache-update.nix" { inherit pkgs; })
  ];

  environment.sessionVariables = {
    EDITOR = "hx";
    NH_FLAKE = "/home/miniluz/nixos-config";
  };

  programs.command-not-found.enable = mkDefault false;
  programs.ssh.startAgent = mkDefault true;
  programs.nix-ld.enable = mkDefault true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = mkDefault true;
  nixpkgs.overlays = [
    inputs.nix-vscode-extensions.overlays.default
  ];

}

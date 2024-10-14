# Configuration common to all computers
{ pkgs, lib, ... }:
let
  mkDefault = lib.mkDefault;
in
{
  # Enable flakes
  nix.settings.experimental-features = mkDefault [ "nix-command" "flakes" ];

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
    extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
    ];
  };

  programs.zsh.enable = true;

  environment.systemPackages = [
    pkgs.file
    pkgs.nixpkgs-fmt
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = lib.mkDefault true;
}

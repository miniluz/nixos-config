# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ pkgs, ... }:
{

  miniluz.visual = false;

  miniluz.selfhosting = {
    enable = true;
    server.enable = true;

    backups.enable = true;

    searxng = true;
    rss = true;
    librechat = true;

    syncthing = true;
    immich = true;
    actual = true;

    jellyfin = true;

    n8n = true;
  };

  networking.hostId = "9555365f";

  nixpkgs.config.packageOverrides = pkgs: {
    intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      libvdpau-va-gl
      vpl-gpu-rt
    ];
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };

  # Install Ghostty terminfo so that SSH sessions from Ghostty can run tmux
  # without "missing or unsuitable terminal: xterm-ghostty" errors.
  environment.systemPackages = [ pkgs.ghostty ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  environment.pathsToLink = [ "/share/zsh" ];

  system.stateVersion = "25.05";

}

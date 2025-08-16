# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  networking.hostId = "9555365f";

  miniluz.visual = false;

  miniluz.selfhosting = {
    enable = true;
    server.enable = true;

    backups.enable = true;

    syncthing = true;
    immich = true;
    actual = true;

    jellyfin = true;
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  environment.pathsToLink = [ "/share/zsh" ];

  system.stateVersion = "25.05";

}

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
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
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = true;

  environment.pathsToLink = [ "/share/zsh" ];

  system.stateVersion = "23.11";

}

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  networking.firewall.enable = false;

  miniluz.gnome.enable = true;
  miniluz.audio = {
    enable = true;
    realtime = {
      enable = true;
      sampleRate = 48000;
      bufferSize = 64;
    };
  };

  miniluz.development = {
    vscode.enable = false;
    podman = true;
    virt = true;
    languages = {
      # java = true;
      # js = true;
      # python = true;
      rust = true;
    };
  };

  miniluz.music.enable = true;

  miniluz.gaming.enable = true;
  miniluz.gaming.minecraft = true;

  miniluz.social.enable = true;

  miniluz.selfhosting = {
    enable = true;
    syncthing = true;
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  environment.pathsToLink = [ "/share/zsh" ];

  system.stateVersion = "24.05"; # Did you read the comment?

}

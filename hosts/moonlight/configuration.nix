# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  ...
}:
{
  miniluz.gnome.enable = true;
  miniluz.audio.enable = true;

  miniluz.intel.enable = true;

  miniluz.development = {
    vscode.enable = true;
    podman = true;
    virt = true;
    languages = {
      # java = true;
      js = true;
      python = true;
      rust = true;
    };
  };
  miniluz.work.enable = true;

  miniluz.social.enable = true;

  miniluz.gaming.enable = true;

  miniluz.selfhosting = {
    enable = true;
    syncthing = true;
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.extraModprobeConfig = ''
    blacklist rtw88_8821ce
  '';

  boot.extraModulePackages = [ config.boot.kernelPackages.rtl8821ce ];

  environment.pathsToLink = [ "/share/zsh" ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}

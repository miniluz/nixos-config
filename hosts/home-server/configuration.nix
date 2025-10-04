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

    # samba = true;
    syncthing = true;
    immich = true;
    actual = true;

    jellyfin = true;
  };

  networking =
    let
      ethernet-interface = "enp2s0";
    in
    {
      hostId = "9555365f";

      networkmanager.unmanaged = [ ethernet-interface ];

      interfaces.${ethernet-interface} = {
        useDHCP = false;
        ipv4.addresses = [
          {
            address = "192.168.50.17";
            prefixLength = 24;
          }
        ];
      };

      defaultGateway.address = "192.168.50.1";
      nameservers = [
        "8.8.8.8"
        "8.8.4.4"
      ];

    };

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

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.zfs.enabled = true;

  environment.pathsToLink = [ "/share/zsh" ];

  system.stateVersion = "25.05";

}

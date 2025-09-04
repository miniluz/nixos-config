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

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  environment.pathsToLink = [ "/share/zsh" ];

  system.stateVersion = "25.05";

}

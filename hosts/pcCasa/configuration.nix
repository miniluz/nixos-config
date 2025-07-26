# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  pkgs,
  inputs,
  paths,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
  ];

  miniluz.gnome.enable = true;
  miniluz.steam.enable = true;
  miniluz.playit.enable = true;

  environment.systemPackages = with pkgs; [
    neovim
    steam-run
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "pccasa"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire =
    {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    }
    // (
      let
        buffer-size = 64;
        sample-rate = 48000;
      in
      let
        buffer-sample-str = "${builtins.toString buffer-size}/${builtins.toString sample-rate}";
      in
      {
        extraConfig.pipewire."92-low-latency" = {
          "context.properties" = {
            default.clock.rate = sample-rate;
            default.clock.quantum = buffer-size;
            default.clock.min-quantum = buffer-size;
            default.clock.max-quantum = buffer-size;
          };
        };

        extraConfig.pipewire-pulse."92-low-latency" = {
          "context.properties" = [
            {
              name = "libpipewire-module-protocol-pulse";
              args = { };
            }
          ];
          "pulse.properties" = {
            "pulse.min.req" = buffer-sample-str;
            "pulse.default.req" = buffer-sample-str;
            "pulse.max.req" = buffer-sample-str;
            "pulse.min.quantum" = buffer-sample-str;
            "pulse.max.quantum" = buffer-sample-str;
          };
          "stream.properties" = {
            "node.latency" = buffer-sample-str;
            "resample.quality" = 1;
          };
        };

        # use the example session manager (no others are packaged yet so this is enabled by default,
        # no need to redefine it in your config for now)
        #media-session.enable = true;
      }
    );

  musnix.enable = true;
  users.users.miniluz.extraGroups = [ "audio" ];

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  home-manager = {
    extraSpecialArgs = { inherit inputs paths; };
    users = {
      "miniluz" = import ./home.nix;
    };
    useGlobalPkgs = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  boot.extraModprobeConfig = ''
    options iwlwifi power_save=1 11n_disable=1
  '';

  environment.pathsToLink = [ "/share/zsh" ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  miniluz.gnome.enable = true;
  miniluz.audio = {
    enable = true;
    realtime = {
      enable = true;
      sampleRate = 48000;
      bufferSize = 256;
    };
  };

  miniluz.development = {
    vscode.enable = true;
    podman = true;
    virt = true;
    languages = {
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

  services.pipewire = {
    extraConfig.pipewire."90-scarlett-defaults" = {
      "context.properties" = {
        # Set Scarlett Line 1-2 as default output
        "default.audio.sink" = "alsa_output.usb-Focusrite_Scarlett_2i4_USB-00.HiFi__Line1__sink";
        # Set Scarlett Input 1 as default input
        "default.audio.source" = "alsa_input.usb-Focusrite_Scarlett_2i4_USB-00.HiFi__Mic1__source";
      };
    };
    wireplumber.extraConfig."51-scarlett-priority" = {
      "monitor.alsa.rules" = [
        # Disable HDMI audio
        {
          matches = [
            { "node.name" = "alsa_output.pci-0000_0c_00.1.hdmi-stereo"; }
          ];
          actions = {
            update-props = {
              "node.disabled" = true;
            };
          };
        }

        # Set high priority for Scarlett outputs
        {
          matches = [
            { "node.name" = "~alsa_output.usb-Focusrite_Scarlett_2i4_USB.*"; }
          ];
          actions = {
            update-props = {
              "priority.driver" = 1000;
              "priority.session" = 1000;
            };
          };
        }

        # Set high priority for Scarlett inputs
        {
          matches = [
            { "node.name" = "~alsa_input.usb-Focusrite_Scarlett_2i4_USB.*"; }
          ];
          actions = {
            update-props = {
              "priority.driver" = 1000;
              "priority.session" = 1000;
            };
          };
        }

        # Lower priority for onboard audio
        {
          matches = [
            { "node.name" = "~alsa_.*pci-0000_0e_00.4.*"; }
          ];
          actions = {
            update-props = {
              "priority.driver" = 100;
              "priority.session" = 100;
            };
          };
        }
      ];
    };
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "sunlight"; # Define your hostname.

  environment.pathsToLink = [ "/share/zsh" ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}

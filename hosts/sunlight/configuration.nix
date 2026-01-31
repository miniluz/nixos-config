# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ pkgs, lib, ... }:
{
  miniluz.amdgpu.enable = true;

  miniluz.gnome.enable = true;
  miniluz.audio = {
    enable = true;
    realtime = {
      enable = true;
      sampleRate = 48000;
      bufferSize = 128;
    };
  };

  miniluz.development = {
    vscode.enable = true;
    containers = true;
    virt = true;
    languages = {
      rust = true;
    };
  };

  miniluz.unity.enable = true;

  miniluz.music.enable = true;

  miniluz.gaming.enable = true;
  miniluz.gaming.minecraft = true;

  miniluz.social.enable = true;

  miniluz.selfhosting = {
    enable = true;
    syncthing = true;
    kodi = true;
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
        {
          matches = [
            { "node.name" = "alsa_input.usb-046d_HD_Pro_Webcam_C920_E4F1F8DF-02.analog-stereo"; }
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

  environment.systemPackages = [
    # Info found with `nix-shell -p pulseaudio --run "pactl list cards"`
    # Important sections:
    # Name: alsa_card.pci-0000_0c_00.1
    # Profiles:
    #     output:hdmi-stereo-extra3: Digital Stereo (HDMI 4) Output (..., available: yes)
    #              WATCH FOR THE HDMI NUMBER --------^^^^^^ also for this ^^^^^^^^^^^^^^
    #     output:hdmi-surround-extra3: Digital Surround 5.1 (HDMI 4) Output (..., available: yes)
    (pkgs.writeShellScriptBin "switch-to-surround" "${lib.getExe' pkgs.pulseaudio "pactl"} set-card-profile alsa_card.pci-0000_0c_00.1 output:hdmi-surround-extra3")
    (pkgs.writeShellScriptBin "switch-to-stereo" "${lib.getExe' pkgs.pulseaudio "pactl"} set-card-profile alsa_card.pci-0000_0c_00.1 output:hdmi-stereo-extra3")
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "sunlight"; # Define your hostname.
  networking.hostId = "0010aec6";

  environment.pathsToLink = [ "/share/zsh" ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}

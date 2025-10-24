{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.miniluz.audio;
in
# To find device configs, run:
# nix-shell -p pulseaudio --run "pactl list sources" | rg Name
# nix-shell -p pulseaudio --run "pactl list sinks" | rg Name
# Example configs:
# services.pipewire = {
#     extraConfig.pipewire."90-scarlett-defaults" = {
#       "context.properties" = {
#         # Set Scarlett Line 1-2 as default output
#         "default.audio.sink" = "alsa_output.usb-Focusrite_Scarlett_2i4_USB-00.HiFi__Line1__sink";
#         # Set Scarlett Input 1 as default input
#         "default.audio.source" = "alsa_input.usb-Focusrite_Scarlett_2i4_USB-00.HiFi__Mic1__source";
#       };
#     };
#     wireplumber.extraConfig."51-scarlett-priority" = {
#       "monitor.alsa.rules" = [
#         # Disable HDMI audio
#         {
#           matches = [
#             { "node.name" = "alsa_output.pci-0000_0c_00.1.hdmi-stereo"; }
#           ];
#           actions = {
#             update-props = {
#               "node.disabled" = true;
#             };
#           };
#         }
#         {
#           matches = [
#             { "node.name" = "alsa_input.usb-046d_HD_Pro_Webcam_C920_E4F1F8DF-02.analog-stereo"; }
#           ];
#           actions = {
#             update-props = {
#               "node.disabled" = true;
#             };
#           };
#         }
#
#         # Set high priority for Scarlett outputs
#         {
#           matches = [
#             { "node.name" = "~alsa_output.usb-Focusrite_Scarlett_2i4_USB.*"; }
#           ];
#           actions = {
#             update-props = {
#               "priority.driver" = 1000;
#               "priority.session" = 1000;
#             };
#           };
#         }
#
#         # Set high priority for Scarlett inputs
#         {
#           matches = [
#             { "node.name" = "~alsa_input.usb-Focusrite_Scarlett_2i4_USB.*"; }
#           ];
#           actions = {
#             update-props = {
#               "priority.driver" = 1000;
#               "priority.session" = 1000;
#             };
#           };
#         }
#
#         # Lower priority for onboard audio
#         {
#           matches = [
#             { "node.name" = "~alsa_.*pci-0000_0e_00.4.*"; }
#           ];
#           actions = {
#             update-props = {
#               "priority.driver" = 100;
#               "priority.session" = 100;
#             };
#           };
#         }
#       ];
#     };
#   };
{
  imports = [
    inputs.musnix.nixosModules.musnix
  ];

  options.miniluz.audio = {
    enable = lib.mkEnableOption "audio";
    realtime = {
      enable = lib.mkEnableOption "realtime audio";
      sampleRate = lib.mkOption {
        default = 48000;
        description = "Sample rate";
      };
      bufferSize = lib.mkOption {
        default = 512;
        description = "Buffer size";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = lib.mkMerge [
      {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
      }
      (
        let
          inherit (cfg.realtime) bufferSize sampleRate;
          bufferSampleStr = "${builtins.toString bufferSize}/${builtins.toString sampleRate}";
        in
        lib.mkIf cfg.realtime.enable {
          extraConfig.pipewire."92-low-latency" = {
            "context.properties" = {
              "default.clock.rate" = sampleRate;
              "default.clock.quantum" = bufferSize;
              "default.clock.min-quantum" = bufferSize;
              "default.clock.max-quantum" = bufferSize;
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
              "pulse.min.req" = bufferSampleStr;
              "pulse.default.req" = bufferSampleStr;
              "pulse.max.req" = bufferSampleStr;
              "pulse.min.quantum" = bufferSampleStr;
              "pulse.max.quantum" = bufferSampleStr;
            };
            "stream.properties" = {
              "node.latency" = bufferSampleStr;
              "resample.quality" = 1;
            };
          };
        }
      )
    ];

    musnix.enable = cfg.realtime.enable;

    environment.systemPackages = lib.mkIf config.miniluz.visual (
      with pkgs;
      [
        pavucontrol
        helvum
        raysession
      ]
    );

    users.users.miniluz = lib.mkIf cfg.realtime.enable { extraGroups = [ "audio" ]; };
  };
}

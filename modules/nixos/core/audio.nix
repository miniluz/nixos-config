{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.miniluz.audio;
in
# To find device configs, run:
# nix-shell -p pulseaudio --run "pactl list sources" | rg Name
# nix-shell -p pulseaudio --run "pactl list sinks" | rg Name
{
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

      minBufferSize = lib.mkOption {
        default = 32;
        description = "Minimum buffer size";
      };

      maxBufferSize = lib.mkOption {
        default = 512;
        description = "Maximum buffer size";
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
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
            inherit (cfg.realtime)
              minBufferSize
              maxBufferSize
              bufferSize
              sampleRate
              ;
          in
          lib.mkIf cfg.realtime.enable {
            extraConfig.pipewire."92-low-latency" = {
              "context.properties" = {
                "default.clock.rate" = sampleRate;
                "default.clock.quantum" = bufferSize;
                "default.clock.min-quantum" = minBufferSize;
                "default.clock.max-quantum" = maxBufferSize;
              };
            };

            wireplumber.extraConfig."99-disable-suspend" = {
              "monitor.alsa.rules" = [
                {
                  matches = [
                    { "node.name" = "~alsa_input.*"; }
                    { "node.name" = "~alsa_output.*"; }
                  ];
                  actions = {
                    update-props = {
                      "session.suspend-timeout-seconds" = 0;
                      # Optional: Tweak by trial-and-error if crackling occurs on specific USB interfaces.
                      # Do not apply globally without testing, as it may break built-in audio.
                      # "api.alsa.period-size" = 2;
                      # "api.alsa.headroom" = 8192;
                    };
                  };
                }
              ];
            };

          }
        )
      ];

      musnix.enable = cfg.realtime.enable;

      environment.systemPackages = lib.mkIf config.miniluz.visual (
        with pkgs;
        [
          pwvucontrol
          pavucontrol
          qpwgraph
          easyeffects

          crosspipe
          raysession
        ]
      );

      users.users.miniluz = lib.mkIf cfg.realtime.enable { extraGroups = [ "audio" ]; };
    })
    (lib.mkIf (cfg.enable && cfg.realtime.enable) {
      boot.kernelPackages = pkgs.linuxPackages_latest;
      boot.kernelParams = [
        "threadirqs"
        "preempt=full"
        "amd_pstate=active" # Zen 4/5: active mode provides best EPP and responsiveness
        "usbcore.autosuspend=-1" # Prevent USB audio interface sleep
      ];

      services.power-profiles-daemon.enable = false;
      powerManagement.cpuFreqGovernor = "performance";
      programs.gamemode.enable = true; # Can elevate priorities for real-time audio applications

      services.pipewire =
        let
          inherit (cfg.realtime)
            minBufferSize
            maxBufferSize
            bufferSize
            sampleRate
            ;
        in
        {
          extraConfig.pipewire."92-low-latency" = {
            "context.properties" = {
              "default.clock.rate" = sampleRate;
              "default.clock.quantum" = bufferSize;
              "default.clock.min-quantum" = minBufferSize;
              "default.clock.max-quantum" = maxBufferSize;
            };
          };

          wireplumber.extraConfig."99-disable-suspend" = {
            "monitor.alsa.rules" = [
              {
                matches = [
                  { "node.name" = "~alsa_input.*"; }
                  { "node.name" = "~alsa_output.*"; }
                ];
                actions = {
                  update-props = {
                    "session.suspend-timeout-seconds" = 0;
                    # Optional: Tweak by trial-and-error if crackling occurs on specific USB interfaces.
                    # Do not apply globally without testing, as it may break built-in audio.
                    "api.alsa.period-size" = 128;
                    "api.alsa.period-num" = 1;
                    # "api.alsa.headroom" = 8192;
                  };
                };
              }
            ];
          };
        };
    })
  ];
}

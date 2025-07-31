{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.miniluz.audio;
in
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
        default = 256;
        description = "Buffer size";
      };
    };
  };

  config = lib.mkIf cfg.enable {
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
          inherit (cfg.realtime) bufferSize sampleRate;
          bufferSampleStr = "${builtins.toString bufferSize}/${builtins.toString sampleRate}";
        in
        lib.mkIf cfg.realtime.enable {
          extraConfig.pipewire."92-low-latency" = {
            "context.properties" = {
              default.clock.rate = sampleRate;
              default.clock.quantum = bufferSize;
              default.clock.min-quantum = bufferSize;
              default.clock.max-quantum = bufferSize;
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
      );

    musnix.enable = cfg.realtime.enable;

    users.users.miniluz = lib.mkIf cfg.realtime.enable { extraGroups = [ "audio" ]; };
  };
}

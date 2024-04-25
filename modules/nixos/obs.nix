{ config, lib, pkgs, ... }:
let
  cfg = config.miniluz.obs-studio;
in
{
  options.miniluz.obs-studio.enable = lib.mkEnableOption "Enable configured git.";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      helvum
      obs-studio
    ];

    # Sources: 
    # * <https://nixos.wiki/wiki/PipeWire#Advanced_Configuration>
    # * <https://gitlab.freedesktop.org/pipewire/pipewire/-/wikis/Virtual-devices#virtual-devices>
    services.pipewire.extraConfig.pipewire."91-null-sinks" = {
      "context.objects" = [
        {
          factory = "adapter";
          args = {
            "factory.name" = "support.null-audio-sink";
            "node.name" = "Virtual Null Output";
            "node.description" = "Virtual Null Output";
            "media.class" = "Audio/Sink";
            "audio.position" = "FL,FR";
            "monitor.passthrough" = true;
            "adapter.auto-port-config" = {
              "mode" = "dsp";
              "monitor" = true;
              "position" = "preserve";
            };
          };
        }
      ];
    };
  };
}

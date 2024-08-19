{ config, pkgs, lib, ... }:
let
  cfg = config.miniluz.skyrim;
in
{
  options.miniluz.skyrim.enable = lib.mkEnableOption "Enable Skyrim changes.";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      dotnet-runtime_7
    ];
  };
}

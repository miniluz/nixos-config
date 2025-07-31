{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.miniluz.intel;
in
{
  options.miniluz.intel.enable = lib.mkEnableOption "Intel graphics support";

  config = lib.mkIf cfg.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [ vpl-gpu-rt ];
    };
  };
}

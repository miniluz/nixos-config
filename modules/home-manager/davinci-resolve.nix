{ config, pkgs, lib, ... }:
let
  cfg = config.miniluz.davinci-resolve;
in
{
  options.miniluz.davinci-resolve.enable = lib.mkEnableOption "Enable DaVinci Resolve.";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.davinci-resolve
    ];
  };
}

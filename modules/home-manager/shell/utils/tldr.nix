{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.miniluz.tldr;
in
{
  options.miniluz.tldr.enable = lib.mkEnableOption "Enable TLDR.";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      tldr
    ];

    services.tldr-update.enable = true;
  };
}

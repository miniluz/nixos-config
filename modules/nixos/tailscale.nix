{
  lib,
  config,
  ...
}:
let
  cfg = config.miniluz.tailscale;
in
{
  options.miniluz.tailscale.enable = lib.mkEnableOption "Tailscale";

  config = lib.mkIf cfg.enable {
    services.tailscale.enable = true;
  };
}

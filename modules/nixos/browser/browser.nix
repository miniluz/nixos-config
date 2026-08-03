{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.miniluz;
  inherit (config.miniluz.constants) miniluz-pkgs;
in
{
  options.miniluz.browser.enable = lib.mkOption {
    default = true;
    description = "Enable browsers.";
  };

  config = lib.mkIf (cfg.browser.enable && cfg.visual) {
    environment.systemPackages = [
      pkgs.tor-browser
      pkgs.chromium
      miniluz-pkgs.zen-luzwrap
    ];
  };

}

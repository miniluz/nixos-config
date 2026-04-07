{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.miniluz;

  prefs = import ./_prefs.nix;
  extensions = import ./_extensions.nix;
  SearchEngines = import ./_search-engines.nix;

in
{
  options.miniluz.browser.enable = lib.mkOption {
    default = true;
    description = "Enable Zen.";
  };

  config = lib.mkIf (cfg.browser.enable && cfg.visual) {
    environment.systemPackages = [
      pkgs.tor-browser
      pkgs.chromium
      (pkgs.wrapFirefox
        inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.zen-browser-unwrapped
        {
          extraPrefs = lib.concatLines (
            lib.mapAttrsToList (
              name: value: "lockPref(${lib.strings.toJSON name}, ${lib.strings.toJSON value});"
            ) prefs
          );

          extraPolicies = {
            DisableTelemetry = true;
            ExtensionSettings = builtins.listToAttrs extensions;

            inherit SearchEngines;
          };
        }
      )
    ];
  };

}

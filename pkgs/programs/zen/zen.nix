{
  wrapFirefox,
  zen-browser-unwrapped,
  lib,
  ...
}:
let
  prefs = import ./_prefs.nix;
  extensions = import ./_extensions.nix;
  SearchEngines = import ./_search-engines.nix;
in
wrapFirefox zen-browser-unwrapped {
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

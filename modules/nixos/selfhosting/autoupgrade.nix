{
  config,
  lib,
  ...
}:
let
  cfg = config.miniluz.selfhosting;
in
{
  config = lib.mkIf (cfg.enable && cfg.server.enable) {

    system.autoUpgrade = {
      enable = true;
      flake = "${config.environment.sessionVariables.NH_FLAKE}#${config.networking.hostName}";
      flags = [
        "--update-input"
        "nixpkgs"
        "--update-input"
        "nixpkgs-unstable"
        "--commit-lock-file"
      ];
      allowReboot = true;
    };

  };
}

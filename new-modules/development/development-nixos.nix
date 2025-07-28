{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.miniluz.development;
in
{
  options.miniluz.development.enable = lib.mkEnableOption "Development Tooling";

  config = lib.mkIf cfg.enable {

    # -- ProbeRS
    services.udev.extraRules = lib.readFile ./probe-rs-rules.rules;

    # -- Podman
    environment.systemPackages = [
      pkgs.podman-compose
    ];

    virtualisation.containers.enable = true;
    virtualisation = {
      podman = {
        enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
      };
    };

    users.users."${cfg.user}" = {
      isNormalUser = true;
      extraGroups = [ "podman" ];
    };
  };
}

{
  config,
  lib,
  pkgs,
  miniluz-pkgs,
  ...
}:
let
  cfg = config.miniluz.selfhosting;
in
{
  config = lib.mkIf (cfg.enable && cfg.server.enable) {
    systemd.services.nixos-upgrade = {
      description = "NixOS Upgrade";

      restartIfChanged = false;
      unitConfig.X-StopOnRemoval = false;

      serviceConfig.Type = "oneshot";

      environment =
        config.nix.envVars
        // {
          inherit (config.environment.sessionVariables) NIX_PATH;
          HOME = "/root";
        }
        // config.networking.proxy.envVars;

      path = with pkgs; [
        coreutils
        # gnutar
        # xz.bin
        # gzip
        gitMinimal
        config.nix.package.out
        # config.programs.ssh.package
      ];

      script =
        let
          flake-location = config.environment.sessionVariables.NH_FLAKE;
        in
        ''
          cd ${flake-location}
          git config --global --add safe.directory ${flake-location}
          git config --global --add safe.directory /home/miniluz/nixos-config-base
          nix flake update --flake ${flake-location} nixpkgs nixpkgs-unstable
          ${lib.getExe (miniluz-pkgs.luznix-update-command.override { inherit flake-location; })}
        '';

      startAt = "9:00";

      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
    };

    systemd.timers.nixos-upgrade = {
      timerConfig = {
        RandomizedDelaySec = "45min";
        Persistent = true;
      };
    };

  };
}

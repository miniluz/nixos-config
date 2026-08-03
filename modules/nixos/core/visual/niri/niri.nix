{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.miniluz.gnome;

  niri-config =
    pkgs.runCommand "niri-config-checked"
      {
        nativeBuildInputs = [ pkgs.niri ];
      }
      ''
        niri validate --config ${./niri-config.kdl}
        cp ${./niri-config.kdl} $out
      '';

  niri = pkgs.symlinkJoin {
    name = "niri";
    paths = [
      pkgs.niri
    ];

    passthru = pkgs.niri.passthru;

    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/niri \
        --add-flag "--config" \
        --add-flag "${niri-config}"
    '';
  };
in
{
  options.miniluz.niri.enable = lib.mkEnableOption "Enable Niri";

  config = lib.mkIf cfg.enable {
    services = {
      displayManager.gdm.enable = true;
    };

    programs = {
      niri = {
        enable = true;
        package = niri;
      };

      waybar.enable = true;

      ssh.startAgent = false;
    };

    security.polkit.enable = true; # polkit
    services.gnome.gnome-keyring.enable = true; # secret service
    security.pam.services.swaylock = { };

    environment.systemPackages = with pkgs; [
      alacritty
      fuzzel
      swaylock
      mako
      swayidle
      xwayland-run
      xwayland-satellite
      nautilus
    ];

  };
}

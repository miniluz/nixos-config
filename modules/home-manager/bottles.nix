{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.miniluz.bottles;
  # yabridge-bottles-wineloader = pkgs.fetchFromGitHub {
  #   owner = "microfortnight";
  #   repo = "yabridge-bottles-wineloader";
  #   rev = "3f4d52baad4347642a4ca6be68e21e6d41780469";
  #   sha256 = "sha256-cC/iXhjyf62zi5lqeBUtsq4VKxeHs74k6yMTDFiOnyo=";
  # };
  pkgs = import inputs.nixpkgs {
    system = "x86_64-linux";
    overlays = [
      (final: prev: {
        wine = prev.wineWowPackages.stable;
      })
    ];
  };
in
{
  options.miniluz.bottles.enable = lib.mkEnableOption "Enable bottles.";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      wine
      winetricks
      bottles
      yq
    ];

    home.sessionVariables."W_NO_WIN64_WARNINGS" = "1";
  };
}

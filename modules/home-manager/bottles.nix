{
  config,
  pkgs,
  lib,
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
in
{
  options.miniluz.bottles.enable = lib.mkEnableOption "Enable bottles.";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      wineWowPackages.stable
      winetricks
      bottles
      yq
    ];

    # home.file.".local/bin/wineloader.sh" = {
    #   source = "${yabridge-bottles-wineloader}/wineloader.sh";
    #   executable = true;
    # };

    # xdg.configFile."environment.d/wineloader.conf" = {
    #   source = "${yabridge-bottles-wineloader}/wineloader.conf";
    # };

    home.sessionVariables."W_NO_WIN64_WARNINGS" = "1";
  };
}

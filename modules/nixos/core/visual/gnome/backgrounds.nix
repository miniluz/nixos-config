{
  pkgs,
  config,
  lib,
  ...
}:
let
  backgrounds-git = pkgs.fetchFromGitHub {
    name = "miniluz-backgrounds";
    owner = "miniluz";
    repo = "backgrounds";
    rev = "b9061904aa40b3c091340f3dfa062e44376d532c";
    hash = "sha256-0Xe8g9DLdrH2jMcPcwZKEV/NFdRBzqUnUPdSLlc8W+A=";
  };
  cfg = config.miniluz.gnome;
in
{
  options.miniluz.gnome.background = {
    enable = lib.mkOption {
      default = true;
      description = "Enable a background";
    };
    path = lib.mkOption {
      type = lib.types.str;
      default = "persona_3_blue_down.png";
      description = "Path of the theme relative to the Git repo";
    };
  };

  config = lib.mkIf (cfg.enable && cfg.background.enable) (
    let
      fileUri = "file://${backgrounds-git}/${cfg.background.path}";
    in
    {
      programs.dconf.profiles.user.databases = [
        {
          settings = {
            "org/gnome/desktop/background" = {
              picture-uri = fileUri;
              picture-uri-dark = fileUri;
            };
            "org/gnome/desktop/screensaver".picture-uri = fileUri;
          };
        }
      ];
    }
  );
}

{ config, pkgs, lib, osConfig, ... }:
let
  cfg = config.miniluz.firefox;
  profile = "miniluz";
  arcwtf = pkgs.fetchFromGitHub {
    owner = "KiKaraage";
    repo = "ArcWTF";
    rev = "73ccc7bd3c8dd130d67746c413ca5cf6a57a9f72";
    hash = "sha256-JzZs0qFaFYaY24o5incgl8u4DGkKASan+b55N+9Jwag=";
  };
in
{
  options.miniluz.firefox.enable = lib.mkEnableOption "Enable Firefox.";

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      profiles.${profile} = {
        name = profile;
        search.default = "DuckDuckGo";

        settings = {
          "extensions.pocket.enabled" = false;

          "browser.toolbars.bookmarks.visibility" = "never";
          "browser.tabs.closeWindowWithLastTab" = false; # don't close the window when closing the last tab

          "signon.rememberSignons" = false;

          # ArcWTF
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "svg.context-properties.content.enabled" = true;
          "uc.tweak.popup-search" = true;
          "uc.tweak.hide-sidebar-header" = true;
          "uc.tweak.longer-sidebar" = true;
        };

        extensions = with osConfig.nur.repos.rycee.firefox-addons; [
          ublock-origin
          bitwarden
          search-by-image
          youtube-shorts-block
          sidebery
          userchrome-toggle
        ];
      };
    };

    # https://github.com/KiKaraage/ArcWTF/issues/69
    home.file = {
      ".mozilla/firefox/${profile}/chrome" = {
        source = arcwtf;
        recursive = true;
      };
    };
  };
}

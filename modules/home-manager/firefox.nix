{ config, pkgs, lib, osConfig, ... }:
let
  cfg = config.miniluz.firefox;
  profile = "miniluz";
  arcwtf = pkgs.fetchFromGitHub {
    owner = "KiKaraage";
    repo = "ArcWTF";
    # rev = "v1.2-firefox"; # This tag can't be used, since the URL bar has still issues
    rev = "bb6f2b7ef7e3d201e23d86bf8636e5d0ea4bd68b";
    hash = "sha256-gyJiIVnyZOYVX6G3m4SSbsb7K9g4zKZWlrHphEIQwsY=";
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

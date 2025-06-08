{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.miniluz.firefox;
  profile = "miniluz";
in
{
  options.miniluz.firefox.enable = lib.mkEnableOption "Enable Firefox.";

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      profiles.${profile} = {
        name = profile;
        search.default = "ddg";

        settings = {
          "extensions.pocket.enabled" = false;

          "browser.toolbars.bookmarks.visibility" = "never";
          "browser.tabs.closeWindowWithLastTab" = false; # don't close the window when closing the last tab
          "sidebar.visibility" = "hide-sidebar";

          "signon.rememberSignons" = false;

          # ArcWTF
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          # "svg.context-properties.content.enabled" = true;
          # "uc.tweak.popup-search" = true;
          # "uc.tweak.hide-sidebar-header" = true;
          # "uc.tweak.longer-sidebar" = true;
        };

        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          bitwarden
          search-by-image
          youtube-shorts-block
          sidebery
        ];
      };
    };

    home.file = {
      ".mozilla/firefox/${profile}/chrome/userChrome.css".source = ./userChrome.css;
      ".mozilla/firefox/${profile}/sidebery-data.json".source = ./sidebery-data.json;
    };

    home.file.".mozilla/firefox/miniluz/search.json.mozlz4".force = lib.mkForce true;
  };
}

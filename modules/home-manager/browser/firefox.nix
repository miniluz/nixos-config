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

      policies = {
        DisableTelemetry = true;
        ExtensionSettings =
          {
            "*".installation_mode = "blocked";
          }
          ++ (
            with builtins;
            let
              extension = shortId: guid: {
                name = guid;
                value = {
                  install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
                  installation_mode = "normal_installed";
                };
              };
            in
            listToAttrs [
              # To add additional extensions, find it on addons.mozilla.org, find
              # the short ID in the url (like https://addons.mozilla.org/en-US/firefox/addon/!SHORT_ID!/)
              # Then go to https://addons.mozilla.org/api/v5/addons/addon/!SHORT_ID!/ to get the guid
              (extension "ublock-origin" "uBlock0@raymondhill.net")
              (extension "bitwarden" "{446900e4-71c2-419f-a6a7-df9c091e268b}")
              (extension "search_by_image" "{2e5ff8c8-32fe-46d0-9fc8-6b8986621f3c}")
              (extension "youtube-shorts-block" "{34daeb50-c2d2-4f14-886a-7160b24d66a4}")
              (extension "sidebery" "{3c078156-979c-498b-8990-85f7987dd929}")
            ]
          );
      };

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
      };
    };

    home.file = {
      ".mozilla/firefox/${profile}/chrome/userChrome.css".source = ./userChrome.css;
      ".mozilla/firefox/${profile}/sidebery-data.json".source = ./sidebery-data.json;
    };

    home.file.".mozilla/firefox/miniluz/search.json.mozlz4".force = lib.mkForce true;
  };
}

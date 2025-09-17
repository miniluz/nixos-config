{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.miniluz;
in
{
  config = lib.mkIf (cfg.firefox.enable && cfg.visual) {
    environment.systemPackages = [
      (inputs.zen-browser.packages.${pkgs.system}.default.override {
        policies = {
          DisableTelemetry = true;
          ExtensionSettings =
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
            (listToAttrs [
              # To add additional extensions, find it on addons.mozilla.org, find
              # the short ID in the url (like https://addons.mozilla.org/en-US/firefox/addon/!SHORT_ID!/)
              # Then go to https://addons.mozilla.org/api/v5/addons/addon/!SHORT_ID!/ to get the guid
              (extension "ublock-origin" "uBlock0@raymondhill.net")
              (extension "bitwarden-password-manager" "{446900e4-71c2-419f-a6a7-df9c091e268b}")
              (extension "search_by_image" "{2e5ff8c8-32fe-46d0-9fc8-6b8986621f3c}")
              (extension "youtube-shorts-block" "{34daeb50-c2d2-4f14-886a-7160b24d66a4}")
              (extension "istilldontcareaboutcookies" "idcac-pub@guus.ninja")
              (extension "sidebery" "{3c078156-979c-498b-8990-85f7987dd929}")
              # (extension "vimium-ff" "{d7742d87-e61d-4b78-b8a1-b469842139fa}")
              (extension "catppuccin-web-file-icons" "{bbb880ce-43c9-47ae-b746-c3e0096c5b76}")
              (extension "untrap-for-youtube" "{2662ff67-b302-4363-95f3-b050218bd72c}")
            ])
            // {
              "*".installation_mode = "blocked";
            };

          SearchEngines = {
            Default = "ddg";
            Add = [
              {
                Name = "nixpkgs packages";
                UrlTemplate = "https://search.nixos.org/packages?query={searchTerms}";
                IconURL = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                Alias = "np";
              }
              {
                Name = "NixOS options";
                UrlTemplate = "https://search.nixos.org/options?query={searchTerms}";
                IronURL = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                Alias = "no";
              }
              {
                Name = "NixOS Wiki";
                UrlTemplate = "https://wiki.nixos.org/w/index.php?search={searchTerms}";
                IconURL = "https://wiki.nixos.org/favicon.ico";
                Alias = "nw";
              }
              {
                Name = "Merriam-Webster";
                UrlTemplate = "https://www.merriam-webster.com/dictionary/{searchTerms}";
                IconURL = "https://www.merriam-webster.com/favicon.ico";
                Alias = "mw";
              }

              {
                Name = "Home Manager Options";
                UrlTemplate = "https://home-manager-options.extranix.com/?query={searchTerms}";
                IconURL = "https://home-manager-options.extranix.com/favicon.ico";
                Alias = "hm";
              }

              {
                Name = "noogle";
                UrlTemplate = "https://noogle.dev/q?term={searchTerms}";
                IconURL = "https://noogle.dev/favicon.ico";
                Alias = "ng";
              }
              {
                Name = "npm-packages";
                UrlTemplate = "https://www.npmjs.com/search?q={searchTerms}";
                IconURL = "https://www.npmjs.com/favicon.ico";
                Alias = "npm";
              }

              {
                Name = "cargo-packages";
                UrlTemplate = "https://lib.rs/search?q={searchTerms}";
                IconURL = "https://lib.rs/favicon.ico";
                Alias = "rs";
              }

            ];
          };

          Preferences = {
            "extensions.autoDisableScopes" = 0;
            "extensions.pocket.enabled" = false;

            "browser.toolbars.bookmarks.visibility" = "never";
            "browser.tabs.closeWindowWithLastTab" = false; # don't close the window when closing the last tab

            "signon.rememberSignons" = false;

            #"toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            "browser.theme.dark-private-windows" = true;
            "extensions.activeThemeID" = "firefox-dark@mozilla.org";
          };
        };
      })
    ];
  };

}

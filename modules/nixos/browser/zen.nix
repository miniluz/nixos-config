{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.miniluz;

  extension = shortId: guid: {
    name = guid;
    value = {
      install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
      installation_mode = "normal_installed";
    };
  };

  prefs = {
    "extensions.autoDisableScopes" = 0;
    "extensions.pocket.enabled" = false;

    "browser.toolbars.bookmarks.visibility" = "never";
    "browser.tabs.closeWindowWithLastTab" = false; # don't close the window when closing the last tab

    "signon.rememberSignons" = false;

    "browser.theme.dark-private-windows" = true;
    "zen.workspaces.separate-essentials" = false;
    "zen.view.compact.enable-at-startup" = true;
  };

  extensions = [
    # To add additional extensions, find it on addons.mozilla.org, find
    # the short ID in the url (like https://addons.mozilla.org/en-US/firefox/addon/!SHORT_ID!/)
    # Then go to https://addons.mozilla.org/api/v5/addons/addon/!SHORT_ID!/ to get the guid
    (extension "ublock-origin" "uBlock0@raymondhill.net")
    (extension "bitwarden-password-manager" "{446900e4-71c2-419f-a6a7-df9c091e268b}")
    (extension "search_by_image" "{2e5ff8c8-32fe-46d0-9fc8-6b8986621f3c}")
    (extension "youtube-shorts-block" "{34daeb50-c2d2-4f14-886a-7160b24d66a4}")
    (extension "istilldontcareaboutcookies" "idcac-pub@guus.ninja")
    # (extension "sidebery" "{3c078156-979c-498b-8990-85f7987dd929}")
    # (extension "vimium-ff" "{d7742d87-e61d-4b78-b8a1-b469842139fa}")
    (extension "catppuccin-web-file-icons" "{bbb880ce-43c9-47ae-b746-c3e0096c5b76}")
    (extension "untrap-for-youtube" "{2662ff67-b302-4363-95f3-b050218bd72c}")
    (extension "wayback-machine_new" "wayback_machine@mozilla.org")
  ];

in
{
  options.miniluz.zen.enable = lib.mkOption {
    default = true;
    description = "Enable Zen.";
  };

  config = lib.mkIf (cfg.zen.enable && cfg.visual) {
    environment.systemPackages = [
      (pkgs.wrapFirefox inputs.zen-browser.packages.${pkgs.system}.zen-browser-unwrapped {
        extraPrefs = lib.concatLines (
          lib.mapAttrsToList (
            name: value: ''lockPref(${lib.strings.toJSON name}, ${lib.strings.toJSON value});''
          ) prefs
        );

        extraPolicies = {
          DisableTelemetry = true;
          ExtensionSettings = builtins.listToAttrs extensions;

          SearchEngines = {
            Default = "ddg";
            Add = [
              {
                Name = "nixpkgs packages";
                URLTemplate = "https://search.nixos.org/packages?query={searchTerms}";
                IconURL = "https://wiki.nixos.org/favicon.ico";
                Alias = "@np";
              }
              {
                Name = "NixOS options";
                URLTemplate = "https://search.nixos.org/options?query={searchTerms}";
                IconURL = "https://wiki.nixos.org/favicon.ico";
                Alias = "@no";
              }
              {
                Name = "NixOS Wiki";
                URLTemplate = "https://wiki.nixos.org/w/index.php?search={searchTerms}";
                IconURL = "https://wiki.nixos.org/favicon.ico";
                Alias = "@nw";
              }
              {
                Name = "Wikipedia (English)";
                URLTemplate = "https://en.wikipedia.org/w/index.php?search={searchTerms}";
                IconURL = "https://en.wikipedia.org/static/favicon/wikipedia.ico";
                Alias = "@wen";
              }
              {
                Name = "Wikipedia (Español)";
                URLTemplate = "https://es.wikipedia.org/w/index.php?search={searchTerms}";
                IconURL = "https://es.wikipedia.org/static/favicon/wikipedia.ico";
                Alias = "@wes";
              }
              {
                Name = "Merriam-Webster";
                URLTemplate = "https://www.merriam-webster.com/dictionary/{searchTerms}";
                IconURL = "https://www.merriam-webster.com/favicon.ico";
                Alias = "@mw";
              }
              {
                Name = "RAE";
                URLTemplate = "https://dle.rae.es/{searchTerms}";
                IconURL = "https://dle.rae.es/favicon-16x16.png";
                Alias = "@rae";
              }
              {
                Name = "Home Manager Options";
                URLTemplate = "https://home-manager-options.extranix.com/?query={searchTerms}";
                IconURL = "https://wiki.nixos.org/favicon.ico";
                Alias = "@hm";
              }
              {
                Name = "noogle";
                URLTemplate = "https://noogle.dev/q?term={searchTerms}";
                IconURL = "https://noogle.dev/favicon.ico";
                Alias = "@ng";
              }
              {
                Name = "npm-packages";
                URLTemplate = "https://www.npmjs.com/search?q={searchTerms}";
                IconURL = "https://www.npmjs.com/favicon.ico";
                Alias = "@npm";
              }
              {
                Name = "cargo-packages";
                URLTemplate = "https://lib.rs/search?q={searchTerms}";
                IconURL = "https://lib.rs/favicon.ico";
                Alias = "@rs";
              }
            ];
          };
        };
      })
    ];
  };

}

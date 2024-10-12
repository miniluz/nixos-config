{ config, pkgs, lib, osConfig, ... }:
let
  cfg = config.miniluz.firefox;
in
{
  options.miniluz.firefox.enable = lib.mkEnableOption "Enable Firefox.";

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      package = pkgs.firefox-beta;
      profiles.miniluz = {
        name = "miniluz";
        search.default = "DuckDuckGo";

        settings = {
          "extensions.pocket.enabled" = false;

          # "widget.non-native-theme.scrollbar.style" = 3;
          # "apz.overscroll.enabled" = false;

          # "browser.compactmode.show" = true;
          "browser.toolbars.bookmarks.visibility" = "never";
          "browser.warnOnQuit" = true; # ask for confirmation when closing a window
          "browser.tabs.warnOnClose" = true; # ask for confirmation when closing a window with multiple tabs
          "browser.tabs.closeWindowWithLastTab" = false; # don't close the window when closing the last tab

          "signon.rememberSignons" = false;
          "sidebar.main.tools" = "";
          "sidebar.position_start" = true;
          "sidebar.revamp" = true;
          "sidebar.verticalTabs" = true;
        };

        extensions = with osConfig.nur.repos.rycee.firefox-addons; [
          ublock-origin
          bitwarden
          search-by-image
          youtube-shorts-block
          tree-style-tabs
        ];
      };
    };
  };
}

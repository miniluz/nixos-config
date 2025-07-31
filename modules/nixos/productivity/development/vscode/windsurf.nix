{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.miniluz.development;
in
{
  config.hm = lib.mkIf (cfg.enable && cfg.vscode.enable) {
    programs.vscode = {
      package = pkgs.windsurf;

      profiles.default = {
        userSettings = {
          "windsurf.marketplaceExtensionGalleryServiceURL" =
            "https://marketplace.visualstudio.com/_apis/public/gallery";
          "windsurf.marketplaceGalleryItemURL" = "https://marketplace.visualstudio.com/items";
        };
      };
    };

    home.packages = with pkgs; [
      miniluz.code-windsurf
    ];

  };
}

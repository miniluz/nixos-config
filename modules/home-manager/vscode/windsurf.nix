{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
let
  cfg = config.miniluz.vscode;
in
{
  options.miniluz.vscode.windsurf = lib.mkEnableOption "Enable Windsurf.";

  config = lib.mkIf cfg.windsurf {
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

    home.packages = [
      (import "${inputs.self}/derivations/code-windsurf.nix" { inherit pkgs; })
    ];

  };
}

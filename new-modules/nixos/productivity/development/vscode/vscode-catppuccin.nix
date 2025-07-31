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

    programs.vscode.profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        catppuccin.catppuccin-vsc
        catppuccin.catppuccin-vsc-icons
      ];

      userSettings = {
        "workbench.colorTheme" = "Catppuccin Mocha";
        "workbench.iconTheme" = "catppuccin-mocha";
        "catppuccin.italicComments" = false;
        "catppuccin.italicKeywords" = false;
        "catppuccin-icons.associations.extensions" = {
          "module.ts" = "nest";
          "entity.ts" = "nest-middleware";
          "provider.ts" = "nest-middleware";
          "controller.ts" = "nest-controller";
          "service.ts" = "nest-service";
        };
      };
    };
  };
}

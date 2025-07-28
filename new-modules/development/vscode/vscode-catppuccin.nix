{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.miniluz.development.vscode;
in
{
  options.miniluz.development.vscode.catppuccin = lib.mkEnableOption "Enable Catppuccin theme.";

  config = lib.mkIf cfg.catppuccin {

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

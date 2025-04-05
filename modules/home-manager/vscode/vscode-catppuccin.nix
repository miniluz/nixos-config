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
  options.miniluz.vscode.catppuccin = lib.mkEnableOption "Enable Catppuccin theme.";

  config = lib.mkIf cfg.catppuccin {

    programs.vscode.extensions = with pkgs.vscode-marketplace; [
      catppuccin.catppuccin-vsc
      catppuccin.catppuccin-vsc-icons
    ];

    programs.vscode.userSettings = {
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
}

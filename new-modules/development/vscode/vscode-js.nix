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
  options.miniluz.development.vscode.js = lib.mkEnableOption "Enable JS support.";

  config = lib.mkIf cfg.js {
    programs.vscode.profiles.default.extensions =
      (with pkgs.vscode-extensions; [
        dbaeumer.vscode-eslint
        esbenp.prettier-vscode
        bradlc.vscode-tailwindcss
      ])
      ++ (with pkgs.vscode-marketplace; [
        lokalise.i18n-ally
        stivo.tailwind-fold
      ]);

    programs.vscode.profiles.default.userSettings =
      let
        prettier-default = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
      in
      {
        "[javascriptreact]" = prettier-default;
        "[typescriptreact]" = prettier-default;
        "[typescript]" = prettier-default;
        "[scss]" = prettier-default;
        "[javascript]" = prettier-default;
        "[html]" = prettier-default;
        "[css]" = prettier-default;
        "[json]" = prettier-default;
      };
  };
}

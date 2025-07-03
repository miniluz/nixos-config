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
  options.miniluz.vscode.js = lib.mkEnableOption "Enable JS support.";

  config = lib.mkIf cfg.js {
    programs.vscode.profiles.default.extensions =
      (with pkgs.vscode-extensions; [
        dbaeumer.vscode-eslint
        esbenp.prettier-vscode
        bradlc.vscode-tailwindcss
        lokalise.i18n-ally
      ])
      ++ (with pkgs.vscode-marketplace; [
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

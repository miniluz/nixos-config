{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.miniluz.development;
in
{
  config.miniluz.development.vscode = lib.mkIf (cfg.enable && cfg.vscode.enable && cfg.languages.js) {
    extensions = with pkgs.vscode-extensions; [
      dbaeumer.vscode-eslint
      esbenp.prettier-vscode
      bradlc.vscode-tailwindcss
      lokalise.i18n-ally
      # stivo.tailwind-fold
    ];

    settings =
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

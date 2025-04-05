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
    programs.vscode.extensions = with pkgs.vscode-marketplace; [
      dbaeumer.vscode-eslint
      esbenp.prettier-vscode
      bradlc.vscode-tailwindcss
      stivo.tailwind-fold
    ];

    programs.vscode.userSettings =
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

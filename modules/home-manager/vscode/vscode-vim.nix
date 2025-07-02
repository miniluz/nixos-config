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
  options.miniluz.vscode.vim = lib.mkEnableOption "Enable Vim emulation.";

  config = lib.mkIf cfg.vim {

    programs.vscode.profiles.default = {
      extensions = with pkgs.vscode-marketplace; [
        vscodevim.vim
      ];

      userSettings = {
        "vim.useCtrlKeys" = false;
        "vim.foldfix" = true;
        "vim.leader" = "<space>";
        "vim.camelCaseMotion.enable" = true;
        "vim.highlightedyank.enable" = true;
        "vim.highlightedyank.color" = "rgba(100, 100, 130, 0.5)";
        "vim.sneak" = true;
        "vim.normalModeKeyBindings" = [
          {
            "before" = [
              "u"
            ];
            "commands" = [
              "undo"
            ];
          }
        ];
      };
    };
  };
}

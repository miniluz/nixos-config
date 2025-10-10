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
  config.miniluz.development.vscode = lib.mkIf (cfg.enable && cfg.vscode.enable) {
    extensions = with pkgs.vscode-extensions; [
      vscodevim.vim
    ];

    settings = {
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
}

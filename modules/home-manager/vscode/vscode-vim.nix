{ pkgs, inputs, config, lib, ... }:
let
  cfg = config.miniluz.vscode;
  nix-vscode-extensions = inputs.nix-vscode-extensions.extensions."x86_64-linux";
in
{
  options.miniluz.vscode.vim = lib.mkEnableOption "Enable Vim emulation.";

  config = lib.mkIf cfg.vim {

    programs.vscode.extensions = with nix-vscode-extensions.vscode-marketplace; [
      vscodevim.vim
    ];


    programs.vscode.userSettings = {
      "vim.useCtrlKeys" = false;
      "vim.foldfix" = true;
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

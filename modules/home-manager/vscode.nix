{ pkgs, config, lib, ... }:
let
  cfg = config.miniluz.vscode;
in
{
  imports = [
    ./firacode.nix
  ];

  options.miniluz.vscode.enable = lib.mkEnableOption "Enable VSCode.";

  config = lib.mkIf cfg.enable {
    programs.direnv.enable = true;
    programs.vscode.enable = true;

    programs.vscode.enableExtensionUpdateCheck = false;
    programs.vscode.enableUpdateCheck = false;
    programs.vscode.mutableExtensionsDir = false;

    programs.vscode.extensions = [
      pkgs.vscode-extensions.catppuccin.catppuccin-vsc
      pkgs.vscode-extensions.catppuccin.catppuccin-vsc-icons
      pkgs.vscode-extensions.gruntfuggly.todo-tree
      pkgs.vscode-extensions.jnoortheen.nix-ide
      pkgs.vscode-extensions.mkhl.direnv
      pkgs.vscode-extensions.ms-kubernetes-tools.vscode-kubernetes-tools
      pkgs.vscode-extensions.ms-vscode-remote.remote-ssh
      pkgs.vscode-extensions.redhat.vscode-yaml
      pkgs.vscode-extensions.rust-lang.rust-analyzer
      pkgs.vscode-extensions.tamasfe.even-better-toml
      pkgs.vscode-extensions.vscodevim.vim
      pkgs.vscode-extensions.dbaeumer.vscode-eslint
      pkgs.vscode-extensions.esbenp.prettier-vscode
    ];

    programs.vscode.userSettings = {
      "editor.fontFamily" = "FiraCode Nerd Font, 'Droid Sans Mono', 'monospace', monospace";
      "editor.fontLigatures" = true;
      "editor.formatOnSave" = true;
      "terminal.integrated.defaultProfile.linux" = "zsh";
      "workbench.sideBar.location" = "right";
      "vim.useCtrlKeys" = false;
      "vim.foldfix" = true;
      "terminal.integrated.scrollback" = 10000;
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
      "workbench.colorTheme" = "Catppuccin Mocha";
      "workbench.iconTheme" = "catppuccin-mocha";
      "catppuccin.italicComments" = false;
      "catppuccin.italicKeywords" = false;
    };
  };
}

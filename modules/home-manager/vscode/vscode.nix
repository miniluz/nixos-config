{ pkgs, inputs, config, lib, ... }:
let
  cfg = config.miniluz.vscode;
  nix-vscode-extensions = inputs.nix-vscode-extensions.extensions."x86_64-linux";
in
{
  imports = [
    ../firacode.nix
    ./vscode-java.nix
    ./vscode-js.nix
  ];

  options.miniluz.vscode.enable = lib.mkEnableOption "Enable VSCode.";

  config = lib.mkIf cfg.enable {
    programs.direnv.enable = true;

    programs.vscode.enable = true;

    programs.vscode.enableExtensionUpdateCheck = false;
    programs.vscode.enableUpdateCheck = false;
    programs.vscode.mutableExtensionsDir = false;

    programs.vscode.extensions = with nix-vscode-extensions.vscode-marketplace; [
      catppuccin.catppuccin-vsc
      catppuccin.catppuccin-vsc-icons

      vscodevim.vim
      gruntfuggly.todo-tree
      jnoortheen.nix-ide
      mkhl.direnv
      vivaxy.vscode-conventional-commits
      ms-vsliveshare.vsliveshare

      ms-kubernetes-tools.vscode-kubernetes-tools
      ms-vscode-remote.remote-ssh
      redhat.vscode-yaml
      tamasfe.even-better-toml

      rust-lang.rust-analyzer
    ];

    programs.vscode.userSettings = {
      "git.autofetch" = "all";
      "git.allowNoVerifyCommit" = true;
      "conventionalCommits.promptFooter" = false;
      "conventionalCommits.promptBody" = false;

      "editor.fontFamily" = "FiraCode Nerd Font, 'Droid Sans Mono', 'monospace', monospace";
      "editor.fontLigatures" = true;
      "editor.formatOnSave" = true;

      "terminal.integrated.defaultProfile.linux" = "zsh";
      "terminal.integrated.scrollback" = 10000;
      "workbench.sideBar.location" = "right";

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

      "workbench.colorTheme" = "Catppuccin Mocha";
      "workbench.iconTheme" = "catppuccin-mocha";
      "catppuccin.italicComments" = false;
      "catppuccin.italicKeywords" = false;


    };
  };
}

{ pkgs, inputs, config, lib, ... }:
let
  cfg = config.miniluz.vscode;
  nix-vscode-extensions = inputs.nix-vscode-extensions.extensions."x86_64-linux";
in
{
  imports = [
    ./vscode-catppuccin.nix
    ./vscode-firacode.nix
    ./vscode-java.nix
    ./vscode-js.nix
    ./vscode-vim.nix
  ];

  options.miniluz.vscode.enable = lib.mkEnableOption "Enable VSCode.";

  config = lib.mkIf cfg.enable {
    programs.direnv.enable = true;

    programs.vscode.enable = true;

    programs.vscode.enableExtensionUpdateCheck = false;
    programs.vscode.enableUpdateCheck = false;
    programs.vscode.mutableExtensionsDir = false;

    programs.vscode.extensions = with nix-vscode-extensions.vscode-marketplace; [
      mkhl.direnv
      jnoortheen.nix-ide

      gruntfuggly.todo-tree
      vivaxy.vscode-conventional-commits

      redhat.vscode-yaml
      tamasfe.even-better-toml

      ms-vsliveshare.vsliveshare
      ms-kubernetes-tools.vscode-kubernetes-tools
      ms-vscode-remote.remote-ssh

      rust-lang.rust-analyzer
    ];

    programs.vscode.userSettings = {
      "git.autofetch" = "all";
      "git.allowNoVerifyCommit" = true;
      "conventionalCommits.promptScopes" = false;
      "conventionalCommits.promptBody" = false;
      "conventionalCommits.promptFooter" = false;

      "editor.formatOnSave" = true;

      "terminal.integrated.defaultProfile.linux" = "zsh";
      "terminal.integrated.scrollback" = 10000;
      "workbench.sideBar.location" = "right";
    };
  };
}

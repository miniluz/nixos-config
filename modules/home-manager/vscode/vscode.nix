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
  imports = [
    ../direnv.nix
    ./vscode-catppuccin.nix
    ./vscode-firacode.nix
    ./vscode-java.nix
    ./vscode-js.nix
    ./vscode-python.nix
    ./vscode-rust.nix
    ./vscode-vim.nix
  ];

  options.miniluz.vscode.enable = lib.mkEnableOption "Enable VSCode.";

  config = lib.mkIf cfg.enable {
    miniluz.direnv.enable = true;

    programs.vscode.enable = true;

    programs.vscode.profiles.default.enableUpdateCheck = false;

    programs.vscode.profiles.default.enableExtensionUpdateCheck = false;
    programs.vscode.mutableExtensionsDir = false;

    programs.vscode.profiles.default.extensions = with pkgs.vscode-marketplace; [
      mkhl.direnv
      jnoortheen.nix-ide

      usernamehw.errorlens
      gruntfuggly.todo-tree
      vivaxy.vscode-conventional-commits

      redhat.vscode-yaml
      tamasfe.even-better-toml

      ms-vsliveshare.vsliveshare
      ms-vscode-remote.remote-ssh

      github.copilot
      github.copilot-chat
    ];

    programs.vscode.profiles.default.userSettings = {
      "git.autofetch" = "all";
      "git.allowNoVerifyCommit" = true;
      "conventionalCommits.promptScopes" = false;
      "conventionalCommits.promptBody" = false;
      "conventionalCommits.promptFooter" = false;

      "editor.formatOnSave" = true;
      "editor.tabCompletion" = "on";

      "terminal.integrated.defaultProfile.linux" = "fish";
      "terminal.integrated.scrollback" = 10000;
      "workbench.sideBar.location" = "right";
    };

    home.sessionVariables = {
      "NIX_CONFIG_EDITOR" = "code-nw";
      "FOO" = "BAR";
    };

    home.packages = [
      (import "${inputs.self}/derivations/code-nw.nix" { inherit pkgs; })
    ];

  };
}

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
  imports = [
    ./vscode-catppuccin.nix
    ./vscode-firacode.nix
    ./vscode-java.nix
    ./vscode-js.nix
    ./vscode-python.nix
    ./vscode-rust.nix
    ./vscode-vim.nix
    ./windsurf.nix
  ];

  config.hm = lib.mkIf (cfg.enable && cfg.vscode.enable) {
    programs.vscode = {
      enable = true;
      mutableExtensionsDir = true;

      profiles.default = {
        enableUpdateCheck = false;
        enableExtensionUpdateCheck = false;

        extensions =
          (with pkgs.vscode-extensions; [
            mkhl.direnv
            jnoortheen.nix-ide

            usernamehw.errorlens

            redhat.vscode-yaml
            tamasfe.even-better-toml

            ms-vsliveshare.vsliveshare
            ms-vscode-remote.remote-ssh
            gruntfuggly.todo-tree
          ])
          ++ (with pkgs.vscode-marketplace; [
            vivaxy.vscode-conventional-commits
          ]);

        userSettings = {
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

          "nix.enableLanguageServer" = true;
          "nix.serverPath" = lib.getExe pkgs.nixd;
          "nix.serverSettings" = {
            "nil" = {
              "formatting" = {
                "command" = [ "nixfmt" ];
              };
            };
            "nixd" = {
              "formatting" = {
                "command" = [ "nixfmt" ];
              };
            };
          };
        };
      };
    };

    home.sessionVariables = lib.mkIf cfg.vscode.nix-editor {
      "NIX_CONFIG_EDITOR" = "code-nw";
    };

    home.packages = with pkgs; [
      miniluz.code-nw
    ];

  };
}

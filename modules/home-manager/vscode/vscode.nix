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
    ../firacode.nix
    ../direnv.nix
    ./vscode-catppuccin.nix
    ./vscode-firacode.nix
    ./vscode-java.nix
    ./vscode-js.nix
    ./vscode-python.nix
    ./vscode-rust.nix
    ./vscode-vim.nix
    ./windsurf.nix
  ];

  options.miniluz.vscode.enable = lib.mkEnableOption "Enable VSCode.";

  config = lib.mkIf cfg.enable {
    miniluz.direnv.enable = true;
    miniluz.firacode.enable = true;

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
          ])
          ++ (with pkgs.vscode-marketplace; [
            gruntfuggly.todo-tree
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

    home.sessionVariables = {
      "NIX_CONFIG_EDITOR" = "code-nw";
    };

    home.packages = [
      (import "${inputs.self}/derivations/code-nw.nix" { inherit pkgs; })
    ];

  };
}

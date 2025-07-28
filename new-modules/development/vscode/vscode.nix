{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.miniluz.development.vscode;
in
{
  imports = [
    ./vscode-catppuccin.nix
    ./vscode-java.nix
    ./vscode-js.nix
    ./vscode-python.nix
    ./vscode-rust.nix
    ./vscode-vim.nix
    ./windsurf.nix
  ];

  options.miniluz.development.vscode = {
    enable = lib.mkEnableOption "Enable VSCode.";
    nix-editor = lib.mkEnableOption "Make VSCode the Nix config editor.";
  };

  config = lib.mkIf cfg.enable {
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
            # ms-vscode-remote.remote-ssh
          ])
          ++ (with pkgs.vscode-marketplace; [
            gruntfuggly.todo-tree
            vivaxy.vscode-conventional-commits
          ])
          ++ (with pkgs.open-vsx; [
            jeanp413.open-remote-ssh
          ]);

        userSettings = {
          "editor.fontFamily" = "FiraCode Nerd Font, 'Droid Sans Mono', 'monospace', monospace";
          "editor.fontLigatures" = true;

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

    home.sessionVariables = lib.mkIf cfg.nix-editor {
      "NIX_CONFIG_EDITOR" = "code-nw";
    };

    home.packages = with pkgs; [
      miniluz.code-nw
    ];

  };
}

{
  pkgs,
  miniluz-pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.miniluz.development;
  json = pkgs.formats.json { };
in
{
  options.miniluz.development.vscode = {
    extensions = lib.mkOption {
      default = [ ];
      type = with lib.types; listOf package;
    };
    settings = lib.mkOption {
      type = json.type;
      default = { };
    };
  };

  config = lib.mkIf (cfg.enable && cfg.vscode.enable) {
    miniluz.development.vscode = {

      extensions = with pkgs.vscode-extensions; [
        mkhl.direnv
        jnoortheen.nix-ide

        usernamehw.errorlens

        redhat.vscode-yaml
        tamasfe.even-better-toml

        ms-vsliveshare.vsliveshare
        ms-vscode-remote.remote-ssh
        gruntfuggly.todo-tree
        # vivaxy.vscode-conventional-commits
      ];

      settings = {
        # "windsurf.marketplaceExtensionGalleryServiceURL" =
        #  "https://marketplace.visualstudio.com/_apis/public/gallery";
        # "windsurf.marketplaceGalleryItemURL" = "https://marketplace.visualstudio.com/items";
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

    hj.xdg.config.files = {
      "Windsurf/User/settings.json".source = lib.mkIf (cfg.vscode.settings != { }) (
        json.generate "settings.json" cfg.vscode.settings
      );
    };

    users.users.miniluz.packages = [
      (pkgs.vscode-with-extensions.override {
        # vscode = pkgs.windsurf;
        vscodeExtensions = config.miniluz.development.vscode.extensions;
      })
    ]
    ++ (with miniluz-pkgs; [
      code-nw
      # code-windsurf
    ]);

    environment.sessionVariables = lib.mkIf cfg.vscode.nix-editor {
      "NIX_CONFIG_EDITOR" = "code-nw";
    };

  };
}

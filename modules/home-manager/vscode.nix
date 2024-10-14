{ pkgs, inputs, config, lib, ... }:
let
  cfg = config.miniluz.vscode;
  nix-vscode-extensions = inputs.nix-vscode-extensions.extensions."x86_64-linux";
in
{
  imports = [
    ./firacode.nix
  ];

  options.miniluz.vscode = {
    enable = lib.mkEnableOption "Enable VSCode.";
    java = lib.mkEnableOption "Enable Java support.";
  };

  config = lib.mkIf cfg.enable
    (
      let
        java = {
          extensions = with nix-vscode-extensions.vscode-marketplace; [
            vscjava.vscode-java-pack
            visualstudioexptteam.vscodeintellicode
            vscjava.vscode-java-debug
            vscjava.vscode-maven
            vscjava.vscode-java-test
            vscjava.vscode-java-dependency
            redhat.java
          ];

          settings = {
            "java.jdt.ls.java.home" = "${pkgs.jdk17}";
          };
        };
      in
      {
        programs.direnv.enable = true;

        programs.vscode.enable = true;
        programs.vscode.package = pkgs.vscode;

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

          dbaeumer.vscode-eslint
          esbenp.prettier-vscode

          rust-lang.rust-analyzer
        ] ++ lib.optionals cfg.java java.extensions;

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

          "[javascriptreact]" = {
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
          };
          "[typescriptreact]" = {
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
          };
          "[typescript]" = {
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
          };
          "[scss]" = {
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
          };
          "[javascript]" = {
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
          };
          "[html]" = {
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
          };
          "[css]" = {
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
          };
          "[json]" = {
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
          };
        } // (if cfg.java then java.settings else { });
      }
    );
}

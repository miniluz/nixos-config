{ pkgs, inputs, config, lib, ... }:
let
  cfg = config.miniluz.vscode;
  nix-vscode-extensions = inputs.nix-vscode-extensions.extensions."x86_64-linux";
in
{
  options.miniluz.vscode.rust = lib.mkEnableOption "Enable Rust support.";

  config = lib.mkIf cfg.rust {

    programs.vscode.extensions = with nix-vscode-extensions.vscode-marketplace; [
      rust-lang.rust-analyzer
      vadimcn.vscode-lldb
    ];


    programs.vscode.userSettings = {
      "todo-tree.regex.regex" = "(//|#|<!--|;|/\\*|^|^[ \\t]*(-|\\d+.))\\s*($TAGS)|todo!";
    };
  };
}

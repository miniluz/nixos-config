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
  options.miniluz.development.vscode.rust = lib.mkEnableOption "Enable Rust support.";

  config = lib.mkIf cfg.rust {

    home.packages = with pkgs; [
      # ffmpeg_7
      lldb
    ];

    programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions; [
      rust-lang.rust-analyzer
      vadimcn.vscode-lldb
    ];

    programs.vscode.profiles.default.userSettings = {
      "todo-tree.regex.regex" = "(//|#|<!--|;|/\\*|^|^[ \\t]*(-|\\d+.))\\s*($TAGS)|todo!";
    };
  };
}

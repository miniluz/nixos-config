{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.miniluz.vscode;
in
{
  options.miniluz.vscode.rust = lib.mkEnableOption "Enable Rust support.";

  config = lib.mkIf cfg.rust {

    home.packages = with pkgs; [
      ffmpeg_7
      lldb
    ];

    programs.vscode.profiles.default.extensions = with pkgs.vscode-marketplace; [
      rust-lang.rust-analyzer
      vadimcn.vscode-lldb
    ];

    programs.vscode.profiles.default.userSettings = {
      "todo-tree.regex.regex" = "(//|#|<!--|;|/\\*|^|^[ \\t]*(-|\\d+.))\\s*($TAGS)|todo!";
    };
  };
}

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
  config.miniluz.development.vscode =
    lib.mkIf (cfg.enable && cfg.vscode.enable && cfg.languages.rust)
      {
        extensions = with pkgs.vscode-extensions; [
          rust-lang.rust-analyzer
          vadimcn.vscode-lldb
        ];

        settings = {
          "todo-tree.regex.regex" = "(//|#|<!--|;|/\\*|^|^[ \\t]*(-|\\d+.))\\s*($TAGS)|todo!";
        };
      };
}

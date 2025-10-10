{
  config,
  lib,
  ...
}:
let
  cfg = config.miniluz.development;
in
{
  config.miniluz.development.vscode = lib.mkIf (cfg.enable && cfg.vscode.enable) {
    settings = {
      "editor.fontFamily" = "FiraCode Nerd Font, 'Droid Sans Mono', 'monospace', monospace";
      "editor.fontLigatures" = true;
    };
  };
}

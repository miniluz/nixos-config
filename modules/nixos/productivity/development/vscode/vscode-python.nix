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
    lib.mkIf (cfg.enable && cfg.vscode.enable && cfg.languages.python)
      {
        extensions = with pkgs.vscode-extensions; [
          ms-python.python
          ms-python.debugpy

          ms-toolsai.jupyter
          ms-toolsai.jupyter-keymap
          ms-toolsai.vscode-jupyter-slideshow
          ms-toolsai.vscode-jupyter-cell-tags
          ms-toolsai.jupyter-renderers
        ];
      };
}

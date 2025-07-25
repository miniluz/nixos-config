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
  options.miniluz.vscode.python = lib.mkEnableOption "Enable Python support.";

  config = lib.mkIf cfg.python {
    programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions; [
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

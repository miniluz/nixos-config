{
  pkgs,
  inputs,
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
    programs.vscode.extensions = with pkgs.vscode-marketplace; [
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

{ pkgs, inputs, config, lib, ... }:
let
  cfg = config.miniluz.vscode;
  nix-vscode-extensions = inputs.nix-vscode-extensions.extensions."x86_64-linux";
in
{
  imports = [ ../firacode.nix ];

  options.miniluz.vscode.firacode = lib.mkEnableOption "Enable Firacode font.";

  config = lib.mkIf cfg.firacode {
    miniluz.firacode.enable = true;

    programs.vscode.userSettings = {
      "editor.fontFamily" = "FiraCode Nerd Font, 'Droid Sans Mono', 'monospace', monospace";
      "editor.fontLigatures" = true;
    };
  };
}

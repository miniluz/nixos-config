{ pkgs, inputs, config, lib, ... }:
let
  cfg = config.miniluz.vscode;
  nix-vscode-extensions = inputs.nix-vscode-extensions.extensions."x86_64-linux";
in
{
  imports = [ ];

  options.miniluz.helix.enable = lib.mkEnableOption "Enable Helix.";

  config = lib.mkIf cfg.enable {
    programs.helix = {
      enable = true;
    };
  };
}

{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
let
  cfg = config.miniluz.nvim;
in
{
  imports = [
    inputs.nvf.homeManagerModules.default
    ../firacode.nix
    ../direnv.nix
  ];

  options.miniluz.nvim = {
    enable = lib.mkEnableOption "Enable Neovim.";
    nix-editor = lib.mkEnableOption "Make Neovim the Nix config editor.";
  };

  config = lib.mkIf cfg.enable {
    miniluz.direnv.enable = true;
    miniluz.firacode.enable = true;

    home.packages = with pkgs; [
      miniluz-nvim.neovim
      nixd
      nixfmt-rfc-style
      wl-clipboard
      wl-clipboard-x11
    ];

    programs.neovide = {
      enable = true;
    };

    home.sessionVariables = lib.mkIf cfg.nix-editor {
      "NIX_CONFIG_EDITOR" = "code-nw";
    };
  };
}

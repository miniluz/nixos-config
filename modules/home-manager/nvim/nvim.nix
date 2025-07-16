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
    enable = lib.mkEnableOption "Neovim.";
    nix-editor = lib.mkEnableOption "Neovim as the Nix config editor.";
    neovide = lib.mkEnableOption "Neovide";
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

    programs.neovide = lib.mkIf cfg.neovide {
      enable = true;
    };

    home.sessionVariables = lib.mkIf cfg.nix-editor {
      "NIX_CONFIG_EDITOR" = if cfg.neovide then "neovide" else "nvim";
    };
  };
}

{
  pkgs,
  config,
  paths,
  lib,
  ...
}:
let
  cfg = config.miniluz.development;
  visual = config.miniluz.visual;
in
{
  config.hm = lib.mkIf (cfg.enable && cfg.nvim.enable) {
    age.secrets.google-ai-lab.file = "${paths.secrets}/google-ai-lab.age";

    home.packages = with pkgs; [
      unstable.miniluz.neovim
      nixd
      nixfmt-rfc-style
      wl-clipboard
      wl-clipboard-x11
    ];

    programs.neovide = lib.mkIf visual {
      enable = true;
    };

    home.sessionVariables = lib.mkIf cfg.nvim.nix-editor {
      "NIX_CONFIG_EDITOR" = if visual then "neovide" else "nvim";
    };
  };
}

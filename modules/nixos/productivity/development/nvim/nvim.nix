{
  pkgs,
  config,
  global-secrets,
  lib,
  miniluz-pkgs-unstable,
  ...
}:
let
  cfg = config.miniluz.development;
in
{
  config.hm = lib.mkIf (cfg.enable && cfg.nvim.enable) {
    age.secrets.google-ai-lab.file = "${global-secrets}/google-ai-lab.age";

    home.packages = with pkgs; [
      miniluz-pkgs-unstable.neovim
      nixd
      nixfmt-rfc-style
      wl-clipboard
      wl-clipboard-x11
      jq
      yq
    ];

    home.sessionVariables = lib.mkIf cfg.nvim.nix-editor {
      "NIX_CONFIG_EDITOR" = "nvim";
    };
  };
}

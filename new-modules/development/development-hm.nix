{
  pkgs,
  config,
  lib,
  paths,
  ...
}:
let
  cfg = config.miniluz.development;
in
{
  imports = [ ./vscode/vscode.nix ];

  options.miniluz.development = {
    enable = lib.mkEnableOption "Development Tooling";
    nix-editor = lib.mkOption { default = "nvim"; };
    nvim = {
      enable = lib.mkEnableOption "Neovim";
      nix-editor = lib.mkEnableOption "Neovim as the Nix config editor";
    };
  };

  config =
    {
      miniluz.development = {
        nvim = {
          enable = lib.mkDefault true;
          neovide = lib.mkDefault true;
          nix-editor = lib.mkDefault true;
        };
        vscode = {
          enable = lib.mkDefault true;
        };
      };
    }
    // lib.mkIf cfg.enable {
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
    }
    // lib.mkIf cfg.enable
    && cfg.nvim.enable {
      age.secrets.google-ai-lab.file = "${paths.secrets}/google-ai-lab.age";

      home.packages = with pkgs; [
        unstable.miniluz.neovim
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

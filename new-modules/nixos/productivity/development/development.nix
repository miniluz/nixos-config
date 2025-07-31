{
  config,
  lib,
  ...
}:
let
  cfg = config.miniluz.development;
in
{
  options.miniluz.development = {
    enable = lib.mkEnableOption "Development tools.";
    vscode = {
      enable = lib.mkOption {
        default = true;
        description = "Enable VSCode";
      };
      nix-editor = lib.mkEnableOption "VSCode as a NixOS config editor.";
    };
    nvim = {
      enable = lib.mkOption {
        default = true;
        description = "Enable NeoVim";
      };
      nix-editor = lib.mkOption {
        default = true;
        description = "Enable NeoVim as the NixOS config editor.";
      };
    };
    podman = lib.mkOption {
      default = true;
      description = "Enable Podman";
    };
    virt = lib.mkOption {
      default = true;
      description = "Enable Virtualization";
    };

    languages = {
      java = lib.mkEnableOption "Java";
      js = lib.mkEnableOption "JS & TS";
      python = lib.mkEnableOption "Python";
      rust = lib.mkEnableOption "Rust";
      # Nix can never be disabled
    };
  };

  config = lib.mkIf cfg.enable {
  };
}

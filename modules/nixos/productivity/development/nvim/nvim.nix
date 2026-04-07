{
  config,
  lib,
  ...
}:
let
  cfg = config.miniluz.development;
  inherit (config.miniluz.constants) miniluz-pkgs global-secrets;
in
{
  config = lib.mkIf (cfg.enable && cfg.nvim.enable) {

    age.secrets.opencode-env = {
      file = "${global-secrets}/opencode-env.age";
      mode = "700";
      owner = "miniluz";
      group = "users";
    };

    environment.sessionVariables = lib.mkMerge [
      (lib.mkIf cfg.nvim.nix-editor {
        "NIX_CONFIG_EDITOR" = "${lib.getExe miniluz-pkgs.luz-neovim}";
      })
      ({ "OPENCODE_ENV" = config.age.secrets.opencode-env.path; })
    ];

  };
}

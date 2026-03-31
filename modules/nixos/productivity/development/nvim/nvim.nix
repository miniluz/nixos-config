{
  miniluz-pkgs,
  config,
  global-secrets,
  lib,
  ...
}:
let
  cfg = config.miniluz.development;
  secretDir = "/run/user/${builtins.toString config.users.users.miniluz.uid}/agenix";
in
{
  config = lib.mkIf (cfg.enable && cfg.nvim.enable) {

    systemd.tmpfiles.rules = [
      "d ${secretDir} 700 miniluz users"
    ];

    age.secrets.opencode-env = {
      file = "${global-secrets}/opencode-env.age";
      path = "${secretDir}/opencode-env";
      mode = "700";
      owner = "miniluz";
      group = "users";
    };

    environment.sessionVariables = lib.mkMerge [
      (lib.mkIf cfg.nvim.nix-editor {
        "NIX_CONFIG_EDITOR" = "${lib.getExe miniluz-pkgs.luz-neovim}";
      })
      ({ "OPENCODE_DIR" = config.age.secrets.opencode-env.path; })
    ];

  };
}

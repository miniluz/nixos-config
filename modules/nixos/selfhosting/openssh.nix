{
  config,
  lib,
  global-secrets,
  ...
}:
let
  cfg = config.miniluz.selfhosting;
in
{
  config = lib.mkIf (cfg.enable && cfg.server.enable) {

    users.users.miniluz.openssh.authorizedKeys.keyFiles = [ "${global-secrets}/miniluz.pub" ];
    services.openssh.enable = true;

  };
}

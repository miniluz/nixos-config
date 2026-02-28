{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.miniluz.selfhosting;
  serverStorage = config.miniluz.selfhosting.server.serverStorage;
  n8nState = "${serverStorage}/n8n";
in
{
  options.miniluz.selfhosting.n8n = lib.mkEnableOption "n8n";

  config = lib.mkIf (cfg.enable && cfg.n8n && cfg.server.enable) {

    miniluz.selfhosting.backups.backups.n8n.paths = [
      n8nState
    ];

    systemd.services.n8n = {
      description = "n8n service";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = {
        GENERIC_TIMEZONE = config.time.timeZone;
        N8N_EDITOR_BASE_URL = "https://n8n.home.miniluz.dev";
        N8N_HOST = "localhost";
        N8N_PORT = "5678";
        N8N_LOG_LEVEL = "debug";
        N8N_USER_FOLDER = n8nState;
        HOME = lib.mkForce n8nState;
        N8N_DIAGNOSTICS_ENABLED = "true";
        # workaround for CVE-2026-0863
        # https://github.com/NixOS/nixpkgs/pull/477422
        N8N_RUNNERS_ENABLED = "true";
        N8N_NATIVE_PYTHON_RUNNER = "true";
      };
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.n8n}/bin/n8n";
        Restart = "on-failure";
        StateDirectory = "n8n";

        # Basic Hardening
        NoNewPrivileges = "yes";
        PrivateTmp = "yes";
        PrivateDevices = "yes";
        DevicePolicy = "closed";
        DynamicUser = "true";
        ProtectSystem = "strict";
        ProtectHome = "read-only";
        ProtectControlGroups = "yes";
        ProtectKernelModules = "yes";
        ProtectKernelTunables = "yes";
        RestrictAddressFamilies = "AF_UNIX AF_INET AF_INET6 AF_NETLINK";
        RestrictNamespaces = "yes";
        RestrictRealtime = "yes";
        RestrictSUIDSGID = "yes";
        MemoryDenyWriteExecute = "no"; # v8 JIT requires memory segments to be Writable-Executable.
        LockPersonality = "yes";
      };
    };
  };

}

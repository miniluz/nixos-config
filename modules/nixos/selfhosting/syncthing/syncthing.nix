# To add a machine:
# 1. Generate the certificates with:
# nix-shell -p syncthing --run "syncthing generate"
# 2. Copy the certificates to ${host-secrets}/syncthing-cert.pem and ${host-secrets}/syncthing-cert-key.age:
# cd $NH_FLAKE/hosts/$(cat /etc/hostname)/secrets
# cp ~/.local/state/syncthing/cert.pem syncthing-cert.pem
# cat ~/.local/state/syncthing/key.pem | agenix -e syncthing-cert-key.age
# 3. Add the device to devices and the relevant folders to folders
{
  config,
  lib,
  host-secrets,
  ...
}:
let
  hostname = config.networking.hostName;

  versioning = {
    type = "staggered";
    params = {
      cleanInterval = "3600"; # Clear every hour
      maxAge = "31536000"; # 1 year
    };
  };

  folder-config = import ./_folders-to-config.nix {
    inherit lib hostname dataDir;
    additionalConfig = { inherit versioning; };
  };

  settings = {
    inherit (folder-config.syncthing) devices folders;

    options = {
      urAccepted = -1;
    };
  };

  cfg = config.miniluz.selfhosting;
  serverStorage = config.miniluz.selfhosting.server.serverStorage;
  dataDir = "${serverStorage}/syncthing";

in
{
  options.miniluz.selfhosting.syncthing = lib.mkEnableOption "Syncthing";

  config = lib.mkMerge [
    (lib.mkIf (cfg.enable && cfg.syncthing && cfg.server.enable) {
      age.secrets.syncthing-cert-key = {
        file = "${host-secrets}/syncthing-cert-key.age";
        mode = "770";
        owner = "syncthing";
        group = "syncthing";
      };

      services.syncthing = {
        enable = true;
        openDefaultPorts = true;
        guiAddress = "127.0.0.1:8384";

        inherit dataDir;

        cert = "${host-secrets}/syncthing-cert.pem";
        key = config.age.secrets.syncthing-cert-key.path;

        inherit settings;
      };

      miniluz.selfhosting.backups.backups = folder-config.backups;
    })
    (lib.mkIf (cfg.enable && cfg.syncthing && !cfg.server.enable) {
      age.secrets.syncthing-cert-key = {
        file = "${host-secrets}/syncthing-cert-key.age";
        mode = "700";
        owner = "miniluz";
        group = "users";
      };

      services.syncthing = {
        enable = true;

        user = "miniluz";
        group = "users";

        cert = "${host-secrets}/syncthing-cert.pem";
        key = config.age.secrets.syncthing-cert-key.path;

        inherit settings;
      };
    })
  ];
}

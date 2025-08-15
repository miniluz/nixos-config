{
  lib,
  hostname,
  additionalConfig,
  dataDir,
}:
let
  devices = import ./_devices.nix;

  syncthingDevicesConfig = lib.filterAttrs (
    deviceName: _deviceConfig: deviceName != hostname
  ) devices;

  allSharedFolders = {
    "~/Polar" = {
      id = "miniluz-polar";
      devices = [
        "home-server"
        "moonlight"
        "sunflare"
      ];
      backup = true;
    };

    "~/Sync" = {
      id = "miniluz-sync";
      devices = builtins.attrNames (import ./_devices.nix);
      backup = true;
    };
  };

  foldersWithHostname = lib.filterAttrs (
    _folder-name: folder-config: lib.any (device: device == hostname) folder-config.devices
  ) allSharedFolders;

  removeHostnameFromFolder = lib.mapAttrs (
    config-name: config-value:
    if (config-name == "devices") then
      lib.filter (device: device != hostname) config-value
    else
      config-value
  );

  folderConfigToSyncthingConfig =
    _folder-name: folder-config:
    lib.pipe folder-config [
      removeHostnameFromFolder
      (lib.filterAttrs (config-name: _: config-name != "backup"))
      (folder: folder // additionalConfig)
    ];

  syncthingFoldersConfig = lib.mapAttrs folderConfigToSyncthingConfig foldersWithHostname;

  folderToBackups = import ./_folder-to-backup.nix {
    inherit lib dataDir;
  };
  backups = folderToBackups foldersWithHostname;
in
{
  syncthing = {
    folders = syncthingFoldersConfig;
    devices = syncthingDevicesConfig;
  };
  inherit backups;
}

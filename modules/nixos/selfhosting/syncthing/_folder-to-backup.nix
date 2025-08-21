{
  lib,
  dataDir,
}:
let

  folderPathToBackupPath =
    path:
    let
      matchResult = builtins.match "^~/(.*)$" path;
    in
    if matchResult != null then "${dataDir}/${builtins.elemAt matchResult 0}" else path;

  folderToBackup =
    folder-name: folder-config:
    lib.nameValuePair "syncthing-${folder-config.id}" {
      paths = [
        (folderPathToBackupPath folder-name)
      ];
    };
in
folders: lib.mapAttrs' folderToBackup (lib.filterAttrs (_n: v: v.backup) folders)

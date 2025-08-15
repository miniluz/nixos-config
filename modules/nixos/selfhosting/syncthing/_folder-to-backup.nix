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
    if folder-config.backup then
      lib.nameValuePair "syncthing-${folder-config.id}" {
        paths = [
          (folderPathToBackupPath folder-name)
        ];
      }
    else
      { };
in
lib.mapAttrs' folderToBackup

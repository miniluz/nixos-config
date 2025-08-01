{ lib, ... }:
# nameValueMap is expected to be { stem, path } -> { name, value }
# pathList is expected to be [ /path/to/file1 /path/to/file2 ]
nameValueMap: pathList:
let
  pathToStemAndPath =
    path:
    let
      stem = lib.pipe path [
        lib.path.splitRoot
        (f: f.subpath)
        lib.path.subpath.components
        lib.lists.last
        (lib.strings.splitString ".")
        (l: lib.lists.sublist 0 (lib.max 1 (lib.length l - 1)) l)
        (builtins.concatStringsSep ".")
      ];
    in
    {
      inherit stem path;
    };
  output = lib.pipe pathList [
    (lib.lists.map pathToStemAndPath)
    (lib.lists.map nameValueMap)
    lib.listToAttrs
  ];
in
output

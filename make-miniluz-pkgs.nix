{ lib, inputs, ... }:
let
  path-to-entry = attrs: path: {
    value = import path attrs;
    name = lib.pipe path [
      lib.path.splitRoot
      (f: f.subpath)
      lib.path.subpath.components
      lib.lists.last
      (lib.strings.splitString ".")
      (lib.lists.dropEnd 1)
      (builtins.concatStringsSep ".")
    ];
  };
  filelist = lib.pipe (inputs.import-tree.withLib lib) [
    (i: i.addPath ./pkgs)
    (i: i.files)
  ];
  miniluz-pkgs =
    attrs:
    lib.pipe filelist [
      (builtins.map (path-to-entry attrs))
      builtins.listToAttrs
    ];
in
miniluz-pkgs

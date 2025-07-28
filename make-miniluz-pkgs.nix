{ lib, inputs, ... }@make-attrs:
attrs:
let
  nameValueMap =
    { stem, path, ... }:
    {
      name = stem;
      value = import path attrs;
    };
  pathList = lib.pipe (inputs.import-tree.withLib lib) [
    (i: i.addPath ./pkgs)
    (i: i.files)
  ];
  makeAttrsetFromPathlist = import ./make-attrset-from-pathlist.nix make-attrs;
in
makeAttrsetFromPathlist nameValueMap pathList

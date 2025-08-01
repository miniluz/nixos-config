{ lib, inputs, ... }@make-attrs:
pkgs:
let
  makeAttrsetFromPathlist = import ./make-attrset-from-pathlist.nix make-attrs;

  callPackage = pkgs.lib.callPackageWith (pkgs // miniluz-pkgs // { inherit miniluz-pkgs; });

  nameValueMap =
    { stem, path, ... }:
    {
      name = stem;
      value = callPackage path { };
    };

  pathList = lib.pipe (inputs.import-tree.withLib lib) [
    (i: i.addPath ./pkgs)
    (i: i.files)
  ];

  neovim =
    (inputs.nvf.lib.neovimConfiguration {
      pkgs = pkgs;
      modules = [ ./nvim/nvim.nix ];
    }).neovim;

  miniluz-pkgs = (makeAttrsetFromPathlist nameValueMap pathList) // {
    inherit neovim;
  };
in
miniluz-pkgs

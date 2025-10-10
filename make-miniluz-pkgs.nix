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

  luz-neovim-unwrapped =
    (inputs.nvf.lib.neovimConfiguration {
      inherit pkgs;
      modules = [ ./nvim/nvim.nix ];
    }).neovim;

  miniluz-pkgs = (makeAttrsetFromPathlist nameValueMap pathList) // {
    inherit luz-neovim-unwrapped;
  };
in
miniluz-pkgs

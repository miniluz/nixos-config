{ lib, ... }@make-attrs:
inputs:
let
  nameValueMap =
    { stem, path, ... }:
    {
      name = stem;
      value = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit (inputs) paths;
        };
        modules = [
          inputs.nixos-modules
          inputs.overlay-module
          "${path}/configuration.nix"
        ];
      };

    };
  hostPath = ./private/hosts;
  pathList = lib.pipe hostPath [
    builtins.readDir
    lib.attrsToList
    (lib.filter ({ value, ... }: value == "directory"))
    (lib.map ({ name, ... }: hostPath + "/${name}"))
  ];
  makeAttrsetFromPathlist = import ./make-attrset-from-pathlist.nix make-attrs;
in
makeAttrsetFromPathlist nameValueMap pathList

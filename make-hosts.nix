{ lib, ... }@make-attrs:
{
  inputs,
  nixos-modules,
  global-secrets,
  miniluz-pkgs,
}:
let
  nameValueMap =
    { stem, path, ... }:
    let
      host-secrets = "${path}/secrets";
      specialArgs = {
        inherit
          inputs
          global-secrets
          host-secrets
          miniluz-pkgs
          ;
      };
    in
    {
      name = stem;
      value = inputs.nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [
          nixos-modules

          "${path}/configuration.nix"
          "${path}/hardware-configuration.nix"

          { networking.hostName = stem; }

          ({
            hjem.linker = inputs.hjem.packages."x86_64-linux".smfh;

            hj = {
              user = "miniluz";
              directory = "/home/miniluz";
            };
          })
          inputs.hjem.nixosModules.default
          (lib.mkAliasOptionModule [ "hj" ] [ "hjem" "users" "miniluz" ])

          inputs.agenix.nixosModules.default
          inputs.nixarr.nixosModules.default
          inputs.quadlet-nix.nixosModules.quadlet
          inputs.nix-index-database.nixosModules.nix-index
        ];
      };

    };
  hostPath = ./hosts;
  pathList = lib.pipe hostPath [
    builtins.readDir
    lib.attrsToList
    (lib.filter ({ value, ... }: value == "directory"))
    (lib.map ({ name, ... }: hostPath + "/${name}"))
  ];
  makeAttrsetFromPathlist = import ./make-attrset-from-pathlist.nix make-attrs;
in
makeAttrsetFromPathlist nameValueMap pathList

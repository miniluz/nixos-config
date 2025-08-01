{ lib, ... }@make-attrs:
{
  inputs,
  paths,
  hm-modules,
  nixos-modules,
  pkgs-unstable,
  miniluz-pkgs,
  miniluz-pkgs-unstable,
}:
let
  nameValueMap =
    { stem, path, ... }:
    let
      specialArgs = {
        inherit
          inputs
          paths
          pkgs-unstable
          miniluz-pkgs
          miniluz-pkgs-unstable
          ;
      };
    in
    {
      name = stem;
      value = inputs.nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [
          nixos-modules

          (lib.mkAliasOptionModule [ "hm" ] [ "home-manager" "users" "miniluz" ])

          "${path}/configuration.nix"
          "${path}/hardware-configuration.nix"

          { networking.hostName = stem; }

          inputs.home-manager.nixosModules.default
          (
            { config, ... }:
            {
              hm = {
                imports = [ hm-modules ];
                home.stateVersion = config.system.stateVersion;
                programs.home-manager.enable = true;
              };

              home-manager = {
                extraSpecialArgs = specialArgs;
                useGlobalPkgs = true;
              };
            }
          )

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

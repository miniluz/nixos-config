{ lib, ... }@make-attrs:
{
  inputs,
  nixos-modules,
  hm-modules,
  private-nixos-modules,
  global-secrets,
  pkgs-unstable,
  miniluz-pkgs,
  miniluz-pkgs-unstable,
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
          private-nixos-modules

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

          inputs.quadlet-nix.nixosModules.quadlet
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

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
    in
    {
      name = stem;
      value = inputs.nixpkgs.lib.nixosSystem {
        modules = [
          nixos-modules

          "${path}/configuration.nix"
          "${path}/hardware-configuration.nix"

          {
            options.miniluz.constants = {
              inputs = lib.mkOption {
                default = inputs;
                description = "Inputs";
              };
              global-secrets = lib.mkOption {
                default = global-secrets;
                description = "Global secrets";
              };
              host-secrets = lib.mkOption {
                default = host-secrets;
                description = "Host secrets";
              };
              miniluz-pkgs = lib.mkOption {
                default = miniluz-pkgs;
                description = "miniluz packages";
              };
            };
          }

          { networking.hostName = stem; }

          (
            { pkgs, ... }:
            {
              hjem.linker = pkgs.smfh;

              hj = {
                user = "miniluz";
                directory = "/home/miniluz";
              };
            }
          )
          inputs.hjem.nixosModules.default
          (lib.mkAliasOptionModule [ "hj" ] [ "hjem" "users" "miniluz" ])

          inputs.musnix.nixosModules.musnix
          inputs.agenix.nixosModules.default
          inputs.nixarr.nixosModules.default
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

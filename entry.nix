let
  inputs = import ./inputs.nix;
  inherit (inputs) nixpkgs nixpkgs-unstable import-tree;

  system = "x86_64-linux";
  lib = nixpkgs.lib;

  paths = {
    secrets = ./private/secrets;
  };

  nixos-modules = import-tree ./modules/nixos;
  hm-modules = import-tree ./modules/home-manager;

  makeMiniluzPkgs = import ./make-miniluz-pkgs.nix { inherit inputs lib; };
  makeHosts = import ./make-hosts.nix { inherit inputs lib; };

  nixpkgs-config = {
    inherit system;
    config.allowUnfree = true;
  };

  pkgs = import nixpkgs nixpkgs-config;
  pkgs-unstable = import nixpkgs-unstable nixpkgs-config;

  miniluz-pkgs = makeMiniluzPkgs pkgs;
  miniluz-pkgs-unstable = makeMiniluzPkgs pkgs-unstable;

in
{
  nixosConfigurations = makeHosts {
    inherit
      inputs
      paths
      nixos-modules
      hm-modules
      pkgs-unstable
      miniluz-pkgs
      miniluz-pkgs-unstable
      ;
  };
}

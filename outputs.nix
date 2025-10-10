inputs:
let
  inherit (inputs)
    nixpkgs
    nixpkgs-unstable
    import-tree
    ;

  system = "x86_64-linux";
  inherit (nixpkgs) lib;

  global-secrets = ./secrets;

  nixos-modules = import-tree ./modules/nixos;

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
      nixos-modules
      global-secrets
      pkgs-unstable
      miniluz-pkgs
      miniluz-pkgs-unstable
      ;
  };

  packages.${system} = { inherit miniluz-pkgs miniluz-pkgs-unstable; };
}

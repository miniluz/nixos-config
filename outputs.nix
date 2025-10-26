inputs:
let
  inherit (inputs)
    nixpkgs
    import-tree
    ;

  system = "x86_64-linux";
  inherit (nixpkgs) lib;

  global-secrets = ./secrets;

  nixos-modules = import-tree ./modules/nixos;

  makeMiniluzPkgs = import ./make-miniluz-pkgs.nix { inherit inputs lib; };
  makeHosts = import ./make-hosts.nix { inherit inputs lib; };

  miniluz-pkgs = makeMiniluzPkgs (
    import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    }
  );

in
{
  nixosConfigurations = makeHosts {
    inherit
      inputs
      nixos-modules
      global-secrets
      miniluz-pkgs
      ;
  };

  packages.${system} = { inherit miniluz-pkgs; };
}

inputs:
let
  inherit (inputs)
    nixpkgs
    nixpkgs-unstable
    import-tree
    self
    ;

  system = "x86_64-linux";
  inherit (nixpkgs) lib;

  global-secrets = "${self}/private/secrets";

  nixos-modules = import-tree "${self}/modules/nixos";
  hm-modules = import-tree "${self}/modules/home-manager";

  private-nixos-modules = import-tree "${self}/private/modules/nixos";

  makeMiniluzPkgs = import "${self}/make-miniluz-pkgs.nix" { inherit inputs lib; };
  makeHosts = import "${self}/make-hosts.nix" { inherit inputs lib; };

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
      hm-modules
      private-nixos-modules
      global-secrets
      pkgs-unstable
      miniluz-pkgs
      miniluz-pkgs-unstable
      ;
  };
}

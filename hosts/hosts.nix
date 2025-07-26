{
  nixpkgs,
  overlay-module,
  nixos-modules,
  paths,
  ...
}@inputs:
{

  home-server = nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit
        inputs
        paths
        ;
    };
    modules = [
      nixos-modules
      overlay-module
      ./home-server/configuration.nix
    ];
  };

  moonlight = nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit
        inputs
        paths
        ;
    };
    modules = [
      nixos-modules
      overlay-module
      ./moonlight/configuration.nix
    ];
  };

  pcCasa = nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit
        inputs
        paths
        ;
    };
    modules = [
      nixos-modules
      overlay-module
      ./pcCasa/configuration.nix
    ];
  };

  starlight = nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit
        inputs
        paths
        ;
    };
    modules = [
      nixos-modules
      overlay-module
      ./starlight/configuration.nix
    ];
  };

  sunlight = nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit
        inputs
        paths
        ;
    };
    modules = [
      nixos-modules
      overlay-module
      ./sunlight/configuration.nix
    ];
  };

}

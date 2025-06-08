{
  description = "NixOS config flake file";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    musnix = {
      url = "github:musnix/musnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    programsdb = {
      url = "github:wamserma/flake-programs-sqlite";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    {
      self,
      nixpkgs,
      nur,
      musnix,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        moonlight = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/moonlight/configuration.nix
          ];
        };

        sunlight = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/sunlight/configuration.nix
          ];
        };

        starlight = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/starlight/configuration.nix
          ];
        };

        pccasa = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            musnix.nixosModules.musnix
            ./hosts/pcCasa/configuration.nix
          ];
        };
      };
    };
}

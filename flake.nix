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

    nur = {
      url = github:nix-community/NUR;
    };

  };

  outputs = { self, nixpkgs, nur, ... }@inputs: {
    nixosConfigurations = {
      moonlight = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          nur.nixosModules.nur
          ./hosts/moonlight/configuration.nix
        ];
      };

      sunlight = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          nur.nixosModules.nur
          ./hosts/sunlight/configuration.nix
        ];
      };

      starlight = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          nur.nixosModules.nur
          ./hosts/starlight/configuration.nix
        ];
      };
    };
  };
}

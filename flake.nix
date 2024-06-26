{
  description = "NixOS config flake file";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    musnix = { url = "github:musnix/musnix"; };

  };

  outputs = { self, nixpkgs, ... }@inputs: {
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
    };
  };
}

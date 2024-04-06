{
  description = "NixOS config flake file";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # TODO: remove
    vscode-server.url = "github:nix-community/nixos-vscode-server";

  };

  outputs = { self, nixpkgs, vscode-server, ... }@inputs: {
    nixosConfigurations = {
      moonlight = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          # TODO: remove
          vscode-server.nixosModules.default
          ({ config, pkgs, ... }: {
            services.vscode-server.enable = true;
          })
          ./hosts/moonlight/configuration.nix
        ];
      };
    };
  };
}

{
  description = "NixOS config flake file";

  nixConfig = {
    extra-substituters = [ "https://playit-nixos-module.cachix.org" ];
    extra-trusted-public-keys = [
      "playit-nixos-module.cachix.org-1:22hBXWXBbd/7o1cOnh+p0hpFUVk9lPdRLX3p5YSfRz4="
    ];
  };

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

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    playit-nixos-module = {
      url = "github:pedorich-n/playit-nixos-module";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    {
      self,
      nixpkgs,
      musnix,
      ...
    }@inputs:
    let
      paths = {
        root = "${self}";
        derivations = "${self}/derivations";
        secrets = "${self}/secrets";
        nixos = "${self}/modules/nixos";
        homeManager = "${self}/modules/home-manager";
      };
    in
    {
      nixosConfigurations = {
        moonlight = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit
              inputs
              paths
              ;
          };
          modules = [
            ./hosts/moonlight/configuration.nix
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
            ./hosts/sunlight/configuration.nix
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
            ./hosts/starlight/configuration.nix
          ];
        };

        pccasa = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit
              inputs
              paths
              ;
          };
          modules = [
            musnix.nixosModules.musnix
            ./hosts/pcCasa/configuration.nix
          ];
        };
      };
    };
}

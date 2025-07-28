{
  description = "miniluz's NixOS & HM modules, packages, and configurations";

  nixConfig = {
    extra-substituters = [ "https://playit-nixos-module.cachix.org" ];
    extra-trusted-public-keys = [
      "playit-nixos-module.cachix.org-1:22hBXWXBbd/7o1cOnh+p0hpFUVk9lPdRLX3p5YSfRz4="
    ];
  };

  inputs = {

    self.submodules = true;

    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
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

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.3-1.tar.gz";
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
      nixpkgs-unstable,
      ...
    }@pre-inputs:
    let
      system = "x86_64-linux";

      paths = {
        secrets = "${self}/private/secrets";
      };

      nixos-modules = import ./modules/nixos/import-all.nix;
      hm-modules = import ./modules/home-manager/import-all.nix;

      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };

      overlays = [
        (final: prev: {
          miniluz = import ./pkgs/miniluz-pkgs.nix {
            inherit inputs;
            lib = nixpkgs.lib;
            pkgs = final;
          };
          unstable = pkgs-unstable // {
            miniluz = import ./pkgs/miniluz-pkgs.nix {
              inherit inputs;
              lib = nixpkgs.lib;
              pkgs = final.unstable;
            };
          };
        })
      ];

      overlay-module = {
        nixpkgs.overlays = overlays;
      };

      pkgs = import nixpkgs {
        inherit system overlays;
        config.allowUnfree = true;
      };

      inputs = pre-inputs // {
        inherit
          nixos-modules
          hm-modules
          overlay-module
          paths
          ;
      };

    in
    {
      inherit overlays nixos-modules hm-modules;
      miniluz = pkgs.miniluz;
      miniluz-unstable = pkgs.unstable.miniluz;

      nixosConfigurations = import ./private/hosts/hosts.nix inputs;
    };
}

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

    import-tree.url = "github:vic/import-tree";

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
      import-tree,
      ...
    }@pre-inputs:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;

      paths = {
        secrets = "${self}/private/secrets";
      };

      nixos-modules = import-tree ./modules/nixos;
      hm-modules = import-tree ./modules/home-manager;

      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };

      make-miniluz-pkgs = import ./make-miniluz-pkgs.nix { inherit inputs lib; };
      # make-miniluz-pkgs =

      overlay = (
        final: prev: {
          miniluz = make-miniluz-pkgs {
            inherit inputs;
            lib = nixpkgs.lib;
            pkgs = final;
          };
          unstable = pkgs-unstable // {
            miniluz = make-miniluz-pkgs {
              inherit inputs;
              lib = nixpkgs.lib;
              pkgs = final.unstable;
            };
          };
        }
      );

      overlay-module = {
        nixpkgs.overlays = [ overlay ];
      };

      pkgs = import nixpkgs {
        inherit system;
        overlays = [ overlay ];
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
      inherit
        overlay
        nixos-modules
        hm-modules
        ;

      miniluz = pkgs.miniluz;
      miniluz-unstable = pkgs.unstable.miniluz;

      nixosConfigurations = import ./private/hosts/hosts.nix inputs;
    };
}

{
  description = "NixOS config flake file";

  nixConfig = {
    extra-substituters = [ "https://playit-nixos-module.cachix.org" ];
    extra-trusted-public-keys = [
      "playit-nixos-module.cachix.org-1:22hBXWXBbd/7o1cOnh+p0hpFUVk9lPdRLX3p5YSfRz4="
    ];
  };

  inputs = {

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
      nvf,
      ...
    }@old-inputs:
    let
      system = "x86_64-linux";

      paths = {
        root = "${self}";
        derivations = "${self}/derivations";
        secrets = "${self}/secrets";
      };

      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };

      miniluz-nvim = nvf.lib.neovimConfiguration {
        pkgs = pkgs-unstable;
        modules = [ ./nvim/nvim.nix ];
      };

      overlay-module = {
        nixpkgs.overlays = [
          (final: prev: {
            inherit miniluz-nvim;
            unstable = pkgs-unstable;
          })
        ];
      };

      nixos-modules = import ./modules/nixos/import-all.nix;
      hm-modules = import ./modules/home-manager/import-all.nix;

      inputs = old-inputs // {
        inherit
          nixos-modules
          hm-modules
          overlay-module
          paths
          ;
      };
    in
    {
      packages.${system}.miniluz-nvim = miniluz-nvim.neovim;

      nixosConfigurations = import ./hosts/hosts.nix inputs;
    };
}

{
  description = "miniluz's NixOS & HM modules, packages, and configurations";

  inputs = {

    #    self.submodules = true;

    null.url = "github:nix-values/null";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.smfh.inputs.systems.follows = "systems";
      inputs.ndg.follows = "";
    };

    musnix = {
      url = "github:musnix/musnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Only for lockfile deduplication
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };
    systems = {
      url = "github:nix-systems/default";
    };

    luz-nvim = {
      url = "github:miniluz/luz-nvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
      inputs.darwin.follows = "";
    };

    import-tree.url = "github:vic/import-tree";

    playit-nixos-module = {
      url = "github:pedorich-n/playit-nixos-module";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      inputs.systems.follows = "systems";
    };

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quadlet-nix.url = "github:SEIAROTg/quadlet-nix";

    nixarr = {
      url = "github:miniluz/nixarr/patch-1";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.website-builder.follows = "null";
    };

    actual-backup = {
      url = "github:miniluz/actual-backup";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.inputs.systems.follows = "systems";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    __flake-compat = {
      url = "git+https://git.lix.systems/lix-project/flake-compat.git";
      flake = false;
    };

  };

  outputs = inputs: import ./outputs.nix inputs;
}

{
  description = "miniluz's NixOS modules and packages";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
      # Can't do this yet because the fix hasn't been upstreamed
      # Also fix on make-hosts
      # inputs.smfh.follows = "";
      inputs.smfh.inputs.nixpkgs.follows = "nixpkgs";
      inputs.smfh.inputs.systems.follows = "systems";
    };

    musnix = {
      url = "github:musnix/musnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Only for lockfile deduplication
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
      inputs.home-manager.follows = "";
    };

    import-tree.url = "github:vic/import-tree";

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixarr = {
      url = "github:miniluz/nixarr/patch-1";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.website-builder.follows = "";
    };

    actual-backup = {
      url = "github:miniluz/actual-backup";
      inputs.nixpkgs.follows = "nixpkgs";
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

#!/bin/bash

# Check that the directory is a git repo
if [ ! -d ".git" ]; then
  echo "Error: This script must be run in a git repository"
  exit 1
fi

# Check if .direnv exists
if [ -f ".envrc" ]; then
  echo "Error: .envrc file already exists"
  exit 1
fi

# Check if nix/flake.nix exists
if [ -f "flake.nix" ]; then
  echo "Error: flake.nix file already exists"
  exit 1
fi

# Create .direnv file
cat >.envrc <<'EOF'
#!/usr/bin/env bash

if ! has nix_direnv_version ; then
  source_url "https://raw.githubusercontent.com/nix-community/nix-direnv/3.0.6/direnvrc" "sha256-RYcUJaRMf8oF5LznDrlCXbkOQrywm0HDv1VjYGaJGdM="
fi

use nix
EOF

# Create or append to .gitignore
if [ -f ".gitignore" ]; then
  if ! grep -Fxq ".direnv" .gitignore; then
    echo ".direnv" >>.gitignore
  fi
else
  echo ".direnv" >.gitignore
fi

# Create nix directory and flake.nix
cat >flake.nix <<'EOF'
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-compat = {
      url = "https://git.lix.systems/lix-project/flake-compat/archive/main.tar.gz";
      flake = false;
    };

  };
  outputs =
    {
      nixpkgs,
      ...
    }:
    let
      inherit (nixpkgs) lib;
    in
    lib.foldl lib.recursiveUpdate { } (
      lib.map
        (
          system:
          let
            pkgs = import nixpkgs { inherit system; };
          in
          with pkgs;
          {
            devShells.${system}.default = mkShell {
              nativeBuildInputs = [
              ];
              buildInputs = [
              ];
            };
          }
        )
        [
          "aarch64-darwin"
          "aarch64-linux"
          "x86_64-darwin"
          "x86_64-linux"
        ]
    );
}
EOF

nix flake update

cat >shell.nix <<'EOF'
let
  lockFile = builtins.fromJSON (builtins.readFile ./flake.lock);
  flake-compat-node = lockFile.nodes.${lockFile.nodes.root.inputs.flake-compat};
  flake-compat = builtins.fetchTarball {
    inherit (flake-compat-node.locked) url;
    sha256 = flake-compat-node.locked.narHash;
  };

  flake = (
    import flake-compat {
      src = ./.;
      copySourceTreeToStore = false;
    }
  );
in
flake.shellNix
EOF

echo "Setup completed successfully!"

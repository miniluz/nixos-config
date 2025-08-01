#!/bin/bash

# Check if .direnv exists
if [ -f ".envrc" ]; then
  echo "Error: .envrc file already exists"
  exit 1
fi

# Check if nix/flake.nix exists
if [ -f "nix/flake.nix" ]; then
  echo "Error: nix/flake.nix file already exists"
  exit 1
fi

# Create .direnv file
cat >.envrc <<'EOF'
#!/usr/bin/env bash

if ! has nix_direnv_version || ! nix_direnv_version 3.0.6; then
  source_url "https://raw.githubusercontent.com/nix-community/nix-direnv/3.0.6/direnvrc" "sha256-RYcUJaRMf8oF5LznDrlCXbkOQrywm0HDv1VjYGaJGdM="
fi

use flake path:$(pwd)/nix
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
mkdir -p nix
cat >nix/flake.nix <<'EOF'
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        with pkgs;
        {
          devShells.default = mkShell {
            nativeBuildInputs = [
            ];
            buildInputs = [
            ];
          };
        }
      );
}
EOF

echo "Setup completed successfully!"


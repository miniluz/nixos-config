#!/usr/bin/env false

nix shell github:miniluz/nixos-config#miniluz-pkgs.luz-shell-utils

nix run github:miniluz/nixos-config#miniluz-pkgs.luz-shell

nix profile install github:miniluz/nixos-config#miniluz-pkgs.luz-shell --extra-experimental-features nix-command --extra-experimental-features flakes

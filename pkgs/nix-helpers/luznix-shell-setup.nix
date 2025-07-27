{ pkgs, ... }:
pkgs.writeShellScriptBin "luznix-shell-setup" (builtins.readFile ./luznix-shell-setup.sh)

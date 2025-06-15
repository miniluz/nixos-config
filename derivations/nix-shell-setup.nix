{ pkgs }: pkgs.writeShellScriptBin "nix-shell-setup" (builtins.readFile ./nix-shell-setup.sh)

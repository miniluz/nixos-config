{ pkgs }: pkgs.writeShellScriptBin "rebuild" (builtins.readFile ./rebuild.sh)

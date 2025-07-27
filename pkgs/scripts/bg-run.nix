{ pkgs, ... }: pkgs.writeShellScriptBin "bg-run" (builtins.readFile ./bg-run.sh)

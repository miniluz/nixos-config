{ pkgs, ... }: pkgs.writeShellScriptBin "code" "windsurf \"$@\""

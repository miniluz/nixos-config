{ pkgs }: pkgs.writeShellScriptBin "code-nw" "code -nw \"$@\""

{ writeShellScriptBin }:
writeShellScriptBin "font-cache-update" ''rm -rf ~/.cache/fontconfig && fc-cache -rv''

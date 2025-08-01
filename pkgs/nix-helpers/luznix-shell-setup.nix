{
  writeShellScriptBin,
  name ? "luznix-shell-setup",
}:
writeShellScriptBin name (builtins.readFile ./luznix-shell-setup.sh)

{
  writeShellScriptBin,
  nixos-rebuild,
  lib,
  flake-location ? "$NH_FLAKE",
}:
writeShellScriptBin "luznixos-raw" ''
  set -euo pipefail

  mode=''${1:?usage: luznixos-raw <switch|boot|test|build|dry-build|build-vm|repl>}

  exec ${lib.getExe nixos-rebuild} "$mode" \
    --no-build-output \
    --show-trace \
    --no-reexec \
    -f "${flake-location}/entry.nix" \
    -A outputs.nixosConfigurations.$(cat /etc/hostname)
''

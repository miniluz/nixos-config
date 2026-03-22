{
  writeShellScriptBin,
  nixos-rebuild,
  lib,
  flake-location ? "$NH_FLAKE",
}:
writeShellScriptBin "luznix-update-command" ''
  ${lib.getExe nixos-rebuild} switch \
    --no-build-output \
    --show-trace \
    --no-reexec \
    -f "${flake-location}/entry.nix" \
    -A outputs.nixosConfigurations.$(cat /etc/hostname)
''

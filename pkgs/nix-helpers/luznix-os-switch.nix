{
  writeShellScriptBin,
  nixos-rebuild,
  expect,
  nix-output-monitor,
  lib,
}:
writeShellScriptBin "luznix-os-switch" ''
  set -exuo pipefail
  sudo -v
  sudo ${lib.getExe' expect "unbuffer"}  ${lib.getExe nixos-rebuild} switch -f "$NH_FLAKE/entry.nix" -A outputs.nixosConfigurations.$(cat /etc/hostname) 2>&1 | ${lib.getExe nix-output-monitor}
''

{
  writeShellScriptBin,
  nixos-rebuild,
  lib,
}:
writeShellScriptBin "luznix-update-command" ''
  ${lib.getExe nixos-rebuild} switch -f "$NH_FLAKE/entry.nix" -A outputs.nixosConfigurations.$(cat /etc/hostname)
''

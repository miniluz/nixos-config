{
  writeShellScriptBin,
  luznixos-raw,
  expect,
  nix-output-monitor,
  lib,
}:
writeShellScriptBin "luznixos" ''
  set -exuo pipefail

  mode=''${1:?usage: luznixos <switch|boot|test|build|dry-build|build-vm|repl>}

  sudo -v

  sudo ${lib.getExe' expect "unbuffer"} \
    ${lib.getExe luznixos-raw} "$mode" \
    2>&1 | ${lib.getExe nix-output-monitor}
''

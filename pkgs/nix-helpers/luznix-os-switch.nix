{
  writeShellScriptBin,
  luznix-update-command,
  expect,
  nix-output-monitor,
  lib,
}:
writeShellScriptBin "luznix-os-switch" ''
  set -exuo pipefail
  sudo -v
  sudo ${lib.getExe' expect "unbuffer"}  ${lib.getExe luznix-update-command} 2>&1 | ${lib.getExe nix-output-monitor}
''

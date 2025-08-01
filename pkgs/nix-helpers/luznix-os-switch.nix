{ writeShellScriptBin, nh }:
writeShellScriptBin "luznix-os-switch" ''
  ${nh}/bin/nh os switch --file "$NH_FLAKE/entry.nix" "nixosConfigurations.$(cat /etc/hostname)" -- --show-trace
''

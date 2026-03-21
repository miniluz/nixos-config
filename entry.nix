{
  outputs = import ./outputs.nix (import ./flake-compat.nix ./.).inputs;
}

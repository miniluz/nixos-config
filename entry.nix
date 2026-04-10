let
  outputs = builtins.toString ./outputs.nix;
  flake-compat = builtins.toString ./flake-compat.nix;
  flake-dir = builtins.toString ./.;
in
{
  outputs = import outputs (import flake-compat flake-dir).inputs;
}

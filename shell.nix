let
  outputs-file = builtins.toString ./outputs.nix;
  flake-compat = builtins.toString ./flake-compat.nix;
  flake-dir = builtins.toString ./.;

  inherit (import flake-compat flake-dir) inputs;
  outputs = import outputs-file inputs;
  pkgs = inputs.nixpkgs.legacyPackages.${builtins.currentSystem};
in
pkgs.mkShell {
  packages = with outputs.packages.${builtins.currentSystem}.miniluz-pkgs; [
    luz-shell
    luz-shell-utils
  ];
}

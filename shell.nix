let
  inherit (import ./flake-compat.nix ./.) inputs;
  outputs = import ./outputs.nix inputs;
  pkgs = inputs.nixpkgs.legacyPackages.${builtins.currentSystem};
in
pkgs.mkShellNoCC {
  packages = with outputs.packages.${builtins.currentSystem}.miniluz-pkgs; [
    luz-shell
    luz-shell-utils
  ];
}

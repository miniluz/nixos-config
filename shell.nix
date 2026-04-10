let
  inherit (import ./flake-compat.nix ./.) inputs;
  outputs = import ./outputs.nix inputs;
  pkgs = inputs.nixpkgs.legacyPackages.${builtins.currentSystem};
in
pkgs.mkShell {
  shellHook = ''
    export OPENSSL_NO_VENDOR=1
    export OPENSSL_LIB_DIR="${pkgs.lib.getLib pkgs.openssl}/lib"
    export OPENSSL_DIR="${pkgs.openssl.dev}"
  '';

  packages =
    (with pkgs; [
      cargo
      rustc
      bacon
      rustfmt
    ])
    ++ (with outputs.packages.${builtins.currentSystem}.miniluz-pkgs; [
      luz-shell
      luz-shell-utils
    ]);
}

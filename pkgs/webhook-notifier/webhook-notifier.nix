{
  rustPlatform,
  lib,
  openssl,
}:
rustPlatform.buildRustPackage {
  pname = "webhook-notifier";
  version = "0.1.0";

  src = ./.;
  cargoLock.lockFile = ./Cargo.lock;

  buildInputs = [ ];

  OPENSSL_NO_VENDOR = 1;
  OPENSSL_LIB_DIR = "${lib.getLib openssl}/lib";
  OPENSSL_DIR = "${openssl.dev}";

  meta.mainProgram = "webhook-notifier";
}

inputs:
let
  inherit (import ./nu-utils.nix inputs) writeNuApplication;
in
writeNuApplication {
  name = "generate-import-all";
  text = builtins.readFile ./generate-import-all.nu;
}

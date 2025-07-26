inputs:
let
  inherit (import ./nu-utils.nix inputs) writeNuApplication;
in
writeNuApplication {
  name = "generate-hosts";
  text = builtins.readFile ./generate-hosts.nu;
}

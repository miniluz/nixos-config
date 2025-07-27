{ pkgs, ... }:
pkgs.miniluz.writeNuApplication {
  name = "luznix-generate-hosts";
  text = builtins.readFile ./luznix-generate-hosts.nu;
}

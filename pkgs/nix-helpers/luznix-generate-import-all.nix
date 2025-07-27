{ pkgs, ... }:
pkgs.miniluz.writeNuApplication {
  name = "luznix-generate-import-all";
  text = builtins.readFile ./luznix-generate-import-all.nu;
}

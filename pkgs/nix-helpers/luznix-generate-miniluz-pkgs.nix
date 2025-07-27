{ pkgs, ... }:
pkgs.miniluz.writeNuApplication {
  name = "luznix-generate-miniluz-pkgs";
  text = builtins.readFile ./luznix-generate-miniluz-pkgs.nu;
}

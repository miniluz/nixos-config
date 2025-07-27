{ pkgs, ... }:
pkgs.miniluz.writeNuApplication {
  name = "luznix-rebuild";
  text = builtins.readFile ./luznix-rebuild.nu;
  runtimeInputs =
    with pkgs;
    [
      libnotify
      nh
      git
      nixfmt-rfc-style
    ]
    ++ (with pkgs.miniluz; [
      luznix-generate-hosts
      luznix-generate-import-all
      luznix-generate-miniluz-pkgs
    ]);
}

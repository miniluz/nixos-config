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
      # luznix-generate-hosts
      # luznix-generate-import-all
      # luznix-generate-miniluz-pkgs
    ]);
  derivationArgs = {
    nativeBuildInputs = [ pkgs.copyDesktopItems ];
    desktopItems = [
      (pkgs.makeDesktopItem {
        name = "Rebuild";
        desktopName = "Luznix Rebuild";
        genericName = "Rebuild NixOS";
        exec = ''${pkgs.nushell}/bin/nu -c luznix-rebuild'';
        terminal = true;
        icon = "utilities-terminal";
      })
    ];
  };
}

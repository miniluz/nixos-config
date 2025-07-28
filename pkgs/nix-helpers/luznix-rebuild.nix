{ pkgs, ... }:
pkgs.miniluz.writeNuApplication {
  name = "luznix-rebuild";
  text = builtins.readFile ./luznix-rebuild.nu;
  runtimeInputs = with pkgs; [
    libnotify
    nh
    git
    nixfmt-rfc-style
  ];
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

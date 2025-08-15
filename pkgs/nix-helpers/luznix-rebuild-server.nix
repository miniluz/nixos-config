{
  writeNuApplication,
  luznix-os-switch,
  git,
  nixfmt-rfc-style,
  name ? "luznix-rebuild-server",
}:
writeNuApplication {
  inherit name;
  text = builtins.readFile ./luznix-rebuild-server.nu;
  runtimeInputs = [
    luznix-os-switch
    git
    nixfmt-rfc-style
  ];
  # derivationArgs = {
  #   nativeBuildInputs = [ pkgs.copyDesktopItems ];
  #   desktopItems = [
  #     (pkgs.makeDesktopItem {
  #       name = "Rebuild";
  #       desktopName = "Luznix Rebuild";
  #       genericName = "Rebuild NixOS";
  #       exec = ''${pkgs.nushell}/bin/nu -c luznix-rebuild'';
  #       terminal = true;
  #       icon = "utilities-terminal";
  #     })
  #   ];
  # };
}

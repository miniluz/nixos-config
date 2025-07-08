{
  pkgs,
  inputs,
  paths,
  ...
}:
{
  imports = [
    inputs.agenix.homeManagerModules.default
  ];

  config = {

    home.packages = with pkgs; [
      inputs.agenix.packages."x86_64-linux".default
      (import "${paths.derivations}/nix-shell-setup.nix" { inherit pkgs; })
      (import "${paths.derivations}/bg-run.nix" { inherit pkgs; })
      trashy
      vlc
    ];

    programs.command-not-found.enable = false;
    programs.nix-index.enable = true;

    age.identityPaths = [ "~/.ssh/id_ed25519" ];

    xdg.desktopEntries = {
      "Rebuild" = {
        name = "Rebuild";
        genericName = "Rebuild NixOS";
        exec = ''bash -c "rebuild ; echo \\"Press enter to close this window...\\" ; read ans" '';
        terminal = true;
        icon = "utilities-terminal";
      };
    };
  };
}

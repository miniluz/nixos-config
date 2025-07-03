{
  pkgs,
  inputs,
  paths,
  ...
}:
{
  imports = [
    inputs.agenix.homeManagerModules.default
    ./rebuild.nix
  ];

  config = {

    miniluz.rebuild = true;

    home.packages = with pkgs; [
      inputs.agenix.packages."x86_64-linux".default
      (import "${paths.derivations}/nix-shell-setup.nix" { inherit pkgs; })
      (import "${paths.derivations}/bg-run.nix" { inherit pkgs; })
      trashy
      vlc
    ];

    age.identityPaths = [ "~/.ssh/id_ed25519" ];

  };
}

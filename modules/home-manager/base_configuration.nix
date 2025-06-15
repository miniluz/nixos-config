{
  pkgs,
  inputs,
  paths,
  ...
}:
{
  imports = [ inputs.agenix.homeManagerModules.default ];

  config = {

    home.packages = with pkgs; [
      inputs.agenix.packages."x86_64-linux".default
      (import "${paths.derivations}/nix-shell-setup.nix" { inherit pkgs; })
      trashy
    ];

    age.identityPaths = [ "~/.ssh/id_ed25519" ];

  };
}

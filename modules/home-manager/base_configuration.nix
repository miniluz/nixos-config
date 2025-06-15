{
  pkgs,
  inputs,
  paths,
  ...
}:
{
  imports = [ inputs.agenix.homeManagerModules.default ];

  config = {

    home.packages = [
      inputs.agenix.packages."x86_64-linux".default
      (import "${paths.derivations}/nix-shell-setup.nix" { inherit pkgs; })
    ];
  };
}

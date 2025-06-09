{
  inputs,
  ...
}:
{
  imports = [ inputs.agenix.homeManagerModules.default ];

  config = {

    home.packages = [
      inputs.agenix.packages."x86_64-linux".default
    ];

    age.identityPaths = [ "~/.ssh/id_ed25519" ];

  };
}

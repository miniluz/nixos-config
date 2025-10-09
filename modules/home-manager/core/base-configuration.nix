{
  inputs,
  ...
}:
{
  imports = [
    inputs.agenix.homeManagerModules.default
  ];

  config = {
    home.username = "miniluz";
    home.homeDirectory = "/home/miniluz";

    age.identityPaths = [ "/home/miniluz/.ssh/id_ed25519" ];
  };
}

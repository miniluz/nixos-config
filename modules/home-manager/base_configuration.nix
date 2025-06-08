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
  };
}

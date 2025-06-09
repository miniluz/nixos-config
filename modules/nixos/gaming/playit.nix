{
  config,
  lib,
  inputs,
  paths,
  ...
}:
let
  cfg = config.miniluz.playit;
in
{
  imports = [
    inputs.playit-nixos-module.nixosModules.default
  ];

  options.miniluz.playit.enable = lib.mkEnableOption "Enable PlayIt.";

  config = lib.mkIf cfg.enable {
    age.secrets.playit.file = "${paths.secrets}/playit.age";

    services.playit = {
      enable = true;
      user = "playit";
      group = "playit";
      secretPath = config.age.secrets.playit.path;
    };
  };
}

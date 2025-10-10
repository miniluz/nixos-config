{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.miniluz.development.languages.rust;
in
{

  config = lib.mkIf cfg {

    users.users.miniluz.packages = with pkgs; [
      lldb
    ];

    services.udev.extraRules = lib.readFile ./probe-rs-rules.rules;

  };
}

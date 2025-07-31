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

    hm.home.packages = with pkgs; [
      lldb
    ];

    services.udev.extraRules = lib.readFile ./probe-rs-rules.rules;

  };
}

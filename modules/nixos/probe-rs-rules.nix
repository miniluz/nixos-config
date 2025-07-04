{
  config,
  lib,
  ...
}:
let
  cfg = config.miniluz.probe-rs-rules;
in
{
  options.miniluz.probe-rs-rules.enable = lib.mkEnableOption "Enable probe-rs-rules.";

  config = lib.mkIf cfg.enable {

    services.udev.extraRules = lib.readFile ./probe-rs-rules.rules;

  };
}

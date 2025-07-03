{
  config,
  lib,
  ...
}:
let
  cfg = config.miniluz.rebuild;
in
{
  options.miniluz.rebuild.enable = lib.mkEnableOption "Enable rebuild.";

  config = lib.mkIf cfg.enable {
    xdg.desktopEntries = {
      "Rebuild" = {
        name = "Rebuild";
        genericName = "Rebuild NixOS";
        exec = "rebuild ; echo \"Press enter to close this window...\" ; read ans";
        terminal = true;
      };
    };
  };
}

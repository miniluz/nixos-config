{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.miniluz.gaming.emulation;
  inherit (config.miniluz.constants) global-secrets;
in
{
  options.miniluz.gaming.emulation = lib.mkEnableOption "Enable emulation.";

  config = lib.mkIf cfg {
    age.secrets.aes_keys.file = "${global-secrets}/aes_keys.age";

    hj.files.".config/retroarch/saves/Citra/sysdata/aes_keys.txt".source =
      config.age.secrets.aes_keys.path;

    environment.systemPackages = with pkgs; [
      (retroarch.withCores (
        cores: with cores; [
          citra
          snes9x
        ]
      ))
    ];

  };
}

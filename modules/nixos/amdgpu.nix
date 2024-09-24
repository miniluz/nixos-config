{ config, lib, pkgs, ... }:
let
  cfg = config.miniluz.amdgpu;
in
{
  options.miniluz.amdgpu.enable = lib.mkEnableOption "Enable AMDGPU support";

  config = lib.mkIf cfg.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    systemd.tmpfiles.rules =
      let
        rocmEnv = pkgs.symlinkJoin {
          name = "rocm-combined";
          paths = with pkgs.rocmPackages; [
            rocblas
            hipblas
            clr
          ];
        };
      in
      [
        "L+    /opt/rocm   -    -    -     -    ${rocmEnv}"
      ];

    environment.systemPackages = [ pkgs.lact ];
    systemd.packages = [ pkgs.lact ];
    systemd.services.lactd.wantedBy = [ "multi-user.target" ];
  };
}

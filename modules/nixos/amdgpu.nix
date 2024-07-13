{ config, lib, pkgs, ... }:
let
  cfg = config.miniluz.amdgpu;
in
{
  options.miniluz.amdgpu.enable = lib.mkEnableOption "Enable GNOME and GDE";

  config = lib.mkIf cfg.enable {
    # AMD. Source: <https://wiki.nixos.org/wiki/AMD_GPU>
    services.xserver.videoDrivers = lib.mkIf config.services.xserver.enable [ "amdgpu" ];

    systemd.tmpfiles.rules = [
      "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
    ];
    hardware.opengl.extraPackages = with pkgs; [
      rocmPackages.clr.icd
      # amdvlk
    ];
    # For 32 bit applications 
    # hardware.opengl.extraPackages32 = with pkgs; [
    #   driversi686Linux.amdvlk
    # ];
  };
}

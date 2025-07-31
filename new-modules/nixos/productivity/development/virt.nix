{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.miniluz.development.virt;
in
{
  config = lib.mkIf cfg {
    # Sources:
    # * <https://nixos.wiki/wiki/Libvirt>
    # * <https://nixos.wiki/wiki/Virt-manager>

    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        # ovmf = {
        #   enable = true;
        #   # packages = [
        #   #   (pkgs.OVMF.override {
        #   #     secureBoot = true;
        #   #     tpmSupport = true;
        #   #   }).fd
        #   # ];
        # };
      };
    };

    programs.virt-manager.enable = true;

    # users.users.miniluz.extraGroups = [ "libvirtd" ];
  };
}

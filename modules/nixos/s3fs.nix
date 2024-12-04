{ config, pkgs, lib, ... }:
let
  cfg = config.miniluz.s3fs;
in
{
  options.miniluz.s3fs.enable = lib.mkEnableOption "Enable s3fs.";

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [
      pkgs.s3fs
    ];

    environment.etc."updatedb.conf".text = ''
      PRUNEFS = fuse.s3f
    '';
  };
}

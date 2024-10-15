{ config, pkgs, lib, ... }:
let
  cfg = config.miniluz.vscode-server;
  nixos-vscode-server = {
    url = "https://github.com/msteen/nixos-vscode-server/tarball/d0ed9b8cf1f0a71f110df9119489ab047e0726bd";
    sha256 = "sha256:1mrc6a1qjixaqkv1zqphgnjjcz9jpsdfs1vq45l1pszs9lbiqfvd";
  };
in
{
  imports = [
    "${fetchTarball nixos-vscode-server}/modules/vscode-server/home.nix"
  ];

  options.miniluz.vscode-server.enable = lib.mkEnableOption "Enable VSCode server.";

  config = lib.mkIf cfg.enable {
    services.vscode-server.enable = true;
  };
}
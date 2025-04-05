{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
let
  cfg = config.miniluz.vscode;
in
{
  options.miniluz.vscode.java = lib.mkEnableOption "Enable Java support.";

  config = lib.mkIf cfg.java {

    programs.vscode.extensions = with pkgs.vscode-marketplace; [
      vscjava.vscode-java-pack
      visualstudioexptteam.vscodeintellicode
      vscjava.vscode-java-debug
      vscjava.vscode-maven
      vscjava.vscode-java-test
      vscjava.vscode-java-dependency
      redhat.java
    ];

    programs.vscode.userSettings = {
      "java.jdt.ls.java.home" = "${pkgs.jdk17}";
    };
  };
}

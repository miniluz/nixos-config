{
  pkgs,
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

    programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions; [
      vscjava.vscode-java-pack
      visualstudioexptteam.vscodeintellicode
      vscjava.vscode-java-debug
      vscjava.vscode-maven
      vscjava.vscode-java-test
      vscjava.vscode-java-dependency
      redhat.java
    ];

    programs.vscode.profiles.default.userSettings = {
      "java.jdt.ls.java.home" = "${pkgs.jdk17}";
    };
  };
}

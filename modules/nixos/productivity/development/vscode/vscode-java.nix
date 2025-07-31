{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.miniluz.development;
in
{
  config.hm = lib.mkIf (cfg.enable && cfg.vscode.enable && cfg.languages.java) {

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

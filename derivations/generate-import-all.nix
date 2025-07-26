{ pkgs }:
pkgs.writeShellApplication {
  name = "rebuild";
  text = builtins.readFile ./rebuild.sh;
  runtimeInputs = with pkgs; [
    libnotify
    jq
    nh
    git
    nixfmt-rfc-style
  ];
}

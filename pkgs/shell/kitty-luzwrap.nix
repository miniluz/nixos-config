{
  symlinkJoin,
  makeWrapper,
  kitty,
  writeTextDir,
  runCommand,
  fetchFromGitHub,
}:
let
  catppuccin-kitty = fetchFromGitHub {
    name = "kitty";
    owner = "catppuccin";
    repo = "kitty";
    rev = "d7d61716a83cd135344cbb353af9d197c5d7cec1";
    hash = "sha256-mRFa+40fuJCUrR1o4zMi7AlgjRtFmii4fNsQyD8hIjM=";
  };
in
symlinkJoin {
  name = "kitty-luzwrap";
  paths = [
    kitty
  ];
  buildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/kitty \
      --set KITTY_CONFIG_DIRECTORY ${
        symlinkJoin {
          name = "kitty-config";
          paths = [
            (writeTextDir "/kitty/kitty.conf" (builtins.readFile ./kitty-config.conf))
            (runCommand "btop-catppuccin" { } ''
              mkdir -p $out/kitty
              ln -sf ${catppuccin-kitty}/themes $out/kitty/themes
            '')
          ];
        }
      }/kitty
  '';
}

{
  symlinkJoin,
  makeWrapper,
  kitty,
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
    mkdir -p $out/kitty
    ln -sf ${./kitty-config.conf} $out/kitty/kitty.conf
    ln -sf ${catppuccin-kitty}/themes $out/kitty/themes

    wrapProgram $out/bin/kitty \
      --set KITTY_CONFIG_DIRECTORY $out/kitty
  '';
}

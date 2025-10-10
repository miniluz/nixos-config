{
  symlinkJoin,
  makeWrapper,
  gitui,
  fetchFromGitHub,
}:
let
  catppuccin-gitui = fetchFromGitHub {
    name = "gitui";
    owner = "catppuccin";
    repo = "gitui";
    rev = "df2f59f847e047ff119a105afff49238311b2d36";
    hash = "sha256-DRK/j3899qJW4qP1HKzgEtefz/tTJtwPkKtoIzuoTj0=";
  };
in
symlinkJoin {
  name = "gitui-luzwrap";
  paths = [
    gitui
  ];
  buildInputs = [ makeWrapper ];
  postBuild = ''
    mkdir -p $out/git
    ln -sf ${./git-config.ini} $out/git/config

    mkdir -p $out/gitui
    ln -sf ${catppuccin-gitui}/themes/catppuccin-mocha.ron $out/gitui/theme.ron

    wrapProgram $out/bin/gitui \
      --add-flag --watcher \
      --set XDG_CONFIG_HOME $out
  '';
}

{
  symlinkJoin,
  makeWrapper,
  ghostty,
  fetchFromGitHub,
}:
let
  catppuccin-ghostty = fetchFromGitHub {
    name = "catppuccin-ghostty";
    owner = "catppuccin";
    repo = "ghostty";
    rev = "0eeefa637affe0b5f29d7005cfe4e143c244a781";
    hash = "sha256-j0HCakM9R/xxEjWd5A0j8VVlg0vQivjlAYHRW/4OpGU=";
  };
in
symlinkJoin {
  name = "ghostty-luzwrap";
  paths = [
    ghostty
  ];
  buildInputs = [ makeWrapper ];
  postBuild = ''
    mkdir -p $out/ghostty
    ln -sf ${./ghostty-config.conf} $out/ghostty/config
    ln -sf ${catppuccin-ghostty}/themes $out/ghostty/themes

    wrapProgram $out/bin/ghostty \
      --add-flag "--config-file=$out/ghostty/config" \
      --add-flag "--theme=$out/ghostty/themes/catppuccin-mocha.conf"
  '';

  meta.mainProgram = "ghostty";
}

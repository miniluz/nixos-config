{
  symlinkJoin,
  makeWrapper,
  btop,
}:
symlinkJoin {
  name = "btop-luzwrap";
  paths = [
    btop
  ];
  buildInputs = [ makeWrapper ];
  postBuild = ''
    mkdir -p $out/btop
    echo 'color_theme = "ayu"' > $out/btop/btop.conf

    wrapProgram $out/bin/btop \
      --set XDG_CONFIG_HOME $out
  '';

  meta.mainProgram = "btop";
}

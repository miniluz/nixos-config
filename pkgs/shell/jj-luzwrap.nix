{
  symlinkJoin,
  makeWrapper,
  jujutsu,
}:
symlinkJoin {
  name = "jj-luzwrap";
  paths = [
    jujutsu
  ];
  buildInputs = [ makeWrapper ];
  postBuild = ''
    mkdir -p $out/jj
    ln -sf ${./jj-config.toml} $out/jj/config.toml

    wrapProgram $out/bin/jj \
      --set XDG_CONFIG_HOME $out
  '';
}

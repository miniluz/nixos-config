{
  symlinkJoin,
  makeWrapper,
  jujutsu,
  writeTextDir,
}:
symlinkJoin {
  name = "jj-luzwrap";
  paths = [
    jujutsu
  ];
  buildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/jj \
      --set XDG_CONFIG_HOME ${writeTextDir "/jj/config.toml" (builtins.readFile ./jj-config.toml)}
  '';
}

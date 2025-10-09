{
  symlinkJoin,
  makeWrapper,
  starship,
}:
symlinkJoin {
  name = "starship-luzwrap";
  paths = [
    starship
  ];
  buildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/starship\
      --set STARSHIP_CONFIG ${./starship-config.toml}
  '';
}

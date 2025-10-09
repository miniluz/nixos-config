{
  symlinkJoin,
  makeWrapper,
  zellij,
}:
symlinkJoin {
  name = "zellij-luzwrap";
  paths = [
    zellij
  ];
  buildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/zellij\
      --set ZELLIJ_CONFIG_FILE ${./zellij-config.kdl}
  '';
}

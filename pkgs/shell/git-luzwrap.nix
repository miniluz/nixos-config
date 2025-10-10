{
  symlinkJoin,
  makeWrapper,
  git,
  delta,
  gnupg,
}:
symlinkJoin {
  name = "git-luzwrap";
  paths = [
    git
    delta
    gnupg
  ];
  buildInputs = [ makeWrapper ];
  postBuild = ''
    mkdir -p $out/git
    ln -sf ${./git-config.ini} $out/git/config

    wrapProgram $out/bin/git \
      --set XDG_CONFIG_HOME $out
  '';
}

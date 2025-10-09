{
  symlinkJoin,
  makeWrapper,
  git,
  delta,
  gnupg,
  writeTextDir,
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
    wrapProgram $out/bin/git \
      --set XDG_CONFIG_HOME ${writeTextDir "/git/config" (builtins.readFile ./git-config.ini)}
  '';
}

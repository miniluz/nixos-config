{
  symlinkJoin,
  makeWrapper,
  btop,
  writeTextDir,
  runCommand,
  fetchFromGitHub,
}:
let
  catppuccin-btop = fetchFromGitHub {
    name = "btop";
    owner = "catppuccin";
    repo = "btop";
    rev = "c6469190f2ecf25f017d6120bf4e050e6b1d17af";
    hash = "sha256-jodJl4f2T9ViNqsY9fk8IV62CrpC5hy7WK3aRpu70Cs=";
  };
in
symlinkJoin {
  name = "btop-luzwrap";
  paths = [
    btop
  ];
  buildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/btop \
      --set XDG_CONFIG_HOME ${
        symlinkJoin {
          name = "btop-config";
          paths = [
            (writeTextDir "/btop/btop.conf" ''color_theme = "catppuccin-mocha"'')
            (runCommand "btop-catppuccin" { } ''
              mkdir -p $out/btop
              ln -sf ${catppuccin-btop}/theme $out/btop/theme
            '')
          ];
        }
      }
  '';
}

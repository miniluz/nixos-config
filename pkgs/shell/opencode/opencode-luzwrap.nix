{
  symlinkJoin,
  makeWrapper,
  opencode,
  dotenv-cli,
}:
symlinkJoin {
  name = "opencode-luzwrap";

  paths = [
    opencode
    dotenv-cli
  ];

  buildInputs = [ makeWrapper ];

  # opencode-config needs to be mounted without toString so it's read only
  postBuild = ''
    wrapProgram $out/bin/opencode\
      --set OPENCODE_CONFIG "${builtins.toString ./opencode-config.jsonc}"\
      --set OPENCODE_CONFIG_DIR "${./opencode-config}"\
      --run '
        if [ -f "$OPENCODE_ENV" ];
        then
          export REQUESTY_API_KEY="$(dotenv -e $OPENCODE_ENV --no-expand -p REQUESTY_API_KEY)";
        else
          echo '\''\''Error: $OPENCODE_ENV not found'\''\'' >&2;
          exit 1;
        fi'
  '';
}

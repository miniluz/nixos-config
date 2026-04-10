{
  stdenvNoCC,
  fetchurl,
  ...
}:
stdenvNoCC.mkDerivation {
  pname = "playit-cli";
  version = "0.17.1";

  src = fetchurl {
    url = "https://github.com/playit-cloud/playit-agent/releases/download/v0.17.1/playit-linux-amd64";
    hash = "sha256-541GPZOqHj7Dagbe1aH0/oeZBf3OuGXfj0zvYST4pVU=";
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;
  doCheck = false;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

    cp $src $out/bin/playit-cli
    chmod +x $out/bin/playit-cli

    runHook postInstall
  '';

  doInstallCheck = false;

  meta.mainProgram = "playit-cli";
}

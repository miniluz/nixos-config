{
  python3Packages,
  systemd,
  curl,
  ...
}:
python3Packages.buildPythonApplication {
  pname = "daily-system-monitor";
  version = "1.0";

  pyproject = false;

  propagatedBuildInputs = [
    systemd
    curl
  ]
  ++ (with python3Packages; [
    requests
    psutil
  ]);

  dontUnpack = true;
  installPhase = "install -Dm755 ${./daily-system-monitor.py} $out/bin/daily-system-monitor";

  meta.mainProgram = "daily-system-monitor";
}

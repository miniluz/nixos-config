{
  python3Packages,
  git,
  ...
}:
python3Packages.buildPythonApplication {
  pname = "git-randomize-commit-times";
  version = "1.0";

  pyproject = false;

  propagatedBuildInputs = [
    git
  ];

  dontUnpack = true;
  installPhase = "install -Dm755 ${./git-randomize-commit-times.py} $out/bin/git-randomize-commit-times";

  meta.mainProgram = "git-randomize-commit-times";
}

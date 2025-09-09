let
  miniluz = builtins.readFile ./miniluz.pub;
in
{
  "syncthing-cert-key.age".publicKeys = [ miniluz ];
}

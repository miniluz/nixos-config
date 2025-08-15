let
  miniluz = builtins.readFile ./miniluz.pub;
in
{
  "syncthing-cert-key.age".publicKeys = [ miniluz ];
  "w0conf.age".publicKeys = [ miniluz ];
  "transmission-env.age".publicKeys = [ miniluz ];
  "nebula.local.key.age".publicKeys = [ miniluz ];
  "actual-sync-id.age".publicKeys = [ miniluz ];
  "actual-password.age".publicKeys = [ miniluz ];
}

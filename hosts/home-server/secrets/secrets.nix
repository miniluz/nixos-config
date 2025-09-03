let
  miniluz = builtins.readFile ./miniluz.pub;
in
{
  "syncthing-cert-key.age".publicKeys = [ miniluz ];
  "w0conf.age".publicKeys = [ miniluz ];
  "transmission-env.age".publicKeys = [ miniluz ];
  "actual-sync-id.age".publicKeys = [ miniluz ];
  "actual-password.age".publicKeys = [ miniluz ];
  "monitoring-webhook.age".publicKeys = [ miniluz ];
  "recyclarr-keys.age".publicKeys = [ miniluz ];
}

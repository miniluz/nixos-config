let
  miniluz = builtins.readFile ./miniluz.pub;
in
{
  "playit.age".publicKeys = [ miniluz ];
  "google-ai-lab.age".publicKeys = [ miniluz ];
}

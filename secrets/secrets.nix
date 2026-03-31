let
  miniluz = builtins.readFile ./miniluz.pub;
in
{
  "google-ai-lab.age".publicKeys = [ miniluz ];
  "opencode-env.age".publicKeys = [ miniluz ];
}

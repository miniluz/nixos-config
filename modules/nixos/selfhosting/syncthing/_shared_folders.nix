{
  "~/Polar" = {
    id = "miniluz-polar";
    devices = [
      "home-server"
      "moonlight"
      "sunflare"
    ];
    backup = true;
  };

  "~/Sync" = {
    id = "miniluz-sync";
    devices = builtins.attrNames (import ./_devices.nix);
    backup = true;
  };

  "~/.local/share/wineprefixes/yabridge" = {
    id = "miniluz-yabridge-prefix";
    devices = [
      "home-server"
      "sunflare"
    ];
    backup = false;
  };
}

{
  symlinkJoin,
  makeWrapper,
  niri,

  alacritty,
  fuzzel,
  swaylock,
  mako,
  swayidle,
  waybar,
  xwayland-run,
  xwayland-satellite,
  nautilus,
}:
symlinkJoin {
  name = "niri";

  paths = [
    niri

    alacritty
    fuzzel
    swaylock
    mako
    swayidle
    waybar
    xwayland-run
    xwayland-satellite
    nautilus
  ];

  passthru.providedSessions = [ "niri" ];

  buildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/niri \
      --add-flag "--config" \
      --add-flag "${builtins.toString ./niri-config.kdl}"
  '';

  meta.mainProgram = "niri";
}

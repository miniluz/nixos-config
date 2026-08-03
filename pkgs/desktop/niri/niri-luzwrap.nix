{
  symlinkJoin,
  makeWrapper,
  niri,

  alacritty,
  fuzzel,
  swaylock,
  mako,
  swayidle,
  swaybg,
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
    swaybg
    waybar
    xwayland-run
    xwayland-satellite
    nautilus
  ];

  passthru.providedSessions = [ "niri" ];

  buildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/niri \
      --set NIRI_CONFIG "${builtins.toString ./niri-config.kdl}"
  '';

  meta.mainProgram = "niri";
}

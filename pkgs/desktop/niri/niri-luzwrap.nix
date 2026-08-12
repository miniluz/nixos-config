{
  symlinkJoin,
  makeWrapper,
  niri,

  alacritty,
  ashell,
  fuzzel,
  swaylock,
  mako,
  swayidle,
  swaybg,
  xwayland-run,
  xwayland-satellite,
  nautilus,
}:
symlinkJoin {
  name = "niri";

  paths = [
    niri

    alacritty
    ashell
    fuzzel
    swaylock
    mako
    swayidle
    swaybg
    xwayland-run
    xwayland-satellite
    nautilus
  ];

  passthru.providedSessions = [ "niri" ];

  buildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/niri \
      --set NIRI_CONFIG "${builtins.toString ./niri-config.kdl}"

    wrapProgram $out/bin/niri-session \
      --set NIRI_CONFIG "${builtins.toString ./niri-config.kdl}"
  '';

  meta.mainProgram = "niri";
}

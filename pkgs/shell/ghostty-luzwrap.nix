{
  symlinkJoin,
  makeWrapper,
  ghostty,
  fetchFromGitHub,
}:
let
  catppuccin-ghostty = fetchFromGitHub {
    name = "catppuccin-ghostty";
    owner = "catppuccin";
    repo = "ghostty";
    rev = "0eeefa637affe0b5f29d7005cfe4e143c244a781";
    hash = "sha256-j0HCakM9R/xxEjWd5A0j8VVlg0vQivjlAYHRW/4OpGU=";
  };
in
symlinkJoin {
  name = "ghostty-luzwrap";
  paths = [
    ghostty
  ];
  buildInputs = [ makeWrapper ];
  postBuild = ''
    mkdir -p $out/ghostty
    ln -sf ${./ghostty-config.conf} $out/ghostty/config
    ln -sf ${catppuccin-ghostty}/themes $out/ghostty/themes

    rm $out/share/applications/com.mitchellh.ghostty.desktop

    cat > $out/share/applications/com.mitchellh.ghostty.desktop <<INI
      [Desktop Entry]
      Version=1.0
      Name=Ghostty
      Type=Application
      Comment=A terminal emulator
      TryExec=$out/bin/ghostty
      Exec=$out/bin/ghostty --gtk-single-instance=true
      Icon=com.mitchellh.ghostty
      Categories=System;TerminalEmulator;
      Keywords=terminal;tty;pty;
      StartupNotify=true
      StartupWMClass=com.mitchellh.ghostty
      Terminal=false
      Actions=new-window;
      X-GNOME-UsesNotifications=true
      X-TerminalArgExec=-e
      X-TerminalArgTitle=--title=
      X-TerminalArgAppId=--class=
      X-TerminalArgDir=--working-directory=
      X-TerminalArgHold=--wait-after-command
      DBusActivatable=true
      X-KDE-Shortcuts=Ctrl+Alt+T

      [Desktop Action new-window]
      Name=New Window
      Exec=$out/bin/ghostty --gtk-single-instance=true
    INI

    wrapProgram $out/bin/ghostty \
      --add-flag "--config-file=$out/ghostty/config" \
      --add-flag "--theme=$out/ghostty/themes/catppuccin-mocha.conf"
  '';

  meta.mainProgram = "ghostty";
}

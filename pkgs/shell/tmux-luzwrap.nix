{
  lib,
  symlinkJoin,
  makeWrapper,
  tmux,
  tmuxPlugins,
  fetchFromGitHub,
  sesh,
  fzf,
  plugins ? with tmuxPlugins; [
    # vim-tmux-navigator
    # catppuccin
    better-mouse-mode
    (tmuxPlugins.mkTmuxPlugin {
      pluginName = "tmux-yank";
      rtpFilePath = "yank.tmux";
      version = "2.3.0";
      src = fetchFromGitHub {
        name = "tmux-yank";
        owner = "tmux-plugins";
        repo = "tmux-yank";
        rev = "fd8000238b324005389076486a2e6e03dba1c64f";
        hash = "sha256-DQQCsBHxOo/BepclkICCtVUAL4pozS/RTJBcVLzICns=";
      };
    })
    (tmuxPlugins.mkTmuxPlugin {
      pluginName = "tmux-ayu-theme";
      rtpFilePath = "tmux-ayu-theme.tmux";
      version = "0.1.0";
      src = fetchFromGitHub {
        name = "tmux-ayu-theme";
        owner = "TechnicalDC";
        repo = "tmux-ayu-theme";
        rev = "2ddd8537e2f98cc760c1e2ded4bcbc62a20b8f42";
        hash = "sha256-/MLP0tE5wSQ/Vcnruy34bQ5kes6AoT0zH2urBcetiq0=";
      };
    })
  ],
}:
symlinkJoin {
  name = "tmux-luzwrap";

  paths = [
    tmux
    sesh
    fzf
  ];

  buildInputs = [ makeWrapper ];
  postBuild = ''
    mkdir $out/tmux
    cat >> $out/tmux/tmux.conf <<EOF
    ${lib.concatMapStringsSep "\n" (plugin: "run-shell ${plugin.rtp}") plugins}

    source-file $out/tmux/tmux-user.conf
    EOF

    ln -sf ${builtins.toString ./tmux-config.conf} $out/tmux/tmux-user.conf

    wrapProgram $out/bin/tmux \
      --add-flags "-f $out/tmux/tmux.conf" \
      --set-default TMUX_TMPDIR '${"\${XDG_RUNTIME_DIR:-\"/run/user/$(id -u)\""}'
  '';

  meta.mainProgram = "tmux";
}

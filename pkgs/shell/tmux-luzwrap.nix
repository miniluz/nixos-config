{
  lib,
  symlinkJoin,
  makeWrapper,
  tmux,
  tmuxPlugins,
  fetchFromGitHub,
  plugins ? with tmuxPlugins; [
    # vim-tmux-navigator
    catppuccin
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
  ],
}:
symlinkJoin {
  name = "tmux-luzwrap";

  paths = [
    (tmux.overrideAttrs {
      src = fetchFromGitHub {
        name = "tmux";
        owner = "tmux";
        repo = "tmux";
        rev = "815f7ecffbf5e7f6daecb3ce6e550bdb32b0d887";
        hash = "sha256-Ze/CXFGvf3H25gCqlPsVCm+0WNwj1A9qqNSwzICFewQ=";
      };
    })
  ];

  buildInputs = [ makeWrapper ];
  postBuild = ''
    mkdir $out/tmux
    cat >> $out/tmux/tmux.conf <<EOF
    ${lib.concatMapStringsSep "\n" (plugin: "run-shell ${plugin.rtp}") plugins}
    EOF
    cat ${./tmux-config.conf} >> $out/tmux/tmux.conf

    wrapProgram $out/bin/tmux \
      --add-flags "-f $out/tmux/tmux.conf" \
      --set-default TMUX_TMPDIR '${"\${XDG_RUNTIME_DIR:-\"/run/user/$(id -u)\""}'
  '';

  meta.mainProgram = "tmux";
}

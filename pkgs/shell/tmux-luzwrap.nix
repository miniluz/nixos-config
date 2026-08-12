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
    (catppuccin.overrideAttrs {
      preInstall = ''
        rm ./themes/catppuccin_mocha_tmux.conf
        cat >> ./themes/catppuccin_mocha_tmux.conf <<EOF
          # vim:set ft=tmux:

          set -ogq @thm_bg "#0f1419"
          set -ogq @thm_fg "#e6e1cf"

          set -ogq @thm_rosewater "#f29718"
          set -ogq @thm_flamingo "#e6e1cf"
          set -ogq @thm_pink "#ffa3aa"
          set -ogq @thm_mauve "#f07178"
          set -ogq @thm_red "#ff6565"
          set -ogq @thm_maroon "#ffa3aa"
          set -ogq @thm_peach "#f29718"
          set -ogq @thm_yellow "#fff779"
          set -ogq @thm_green "#b8cc52"
          set -ogq @thm_teal "#95e6cb"
          set -ogq @thm_sky "#c7fffd"
          set -ogq @thm_sapphire "#68d5ff"
          set -ogq @thm_blue "#36a3d9"
          set -ogq @thm_lavender "#c7fffd"

          set -ogq @thm_subtext_1 "#95e6cb"
          set -ogq @thm_subtext_0 "#95e6cb"
          set -ogq @thm_overlay_2 "#253340"
          set -ogq @thm_overlay_1 "#36a3d9"
          set -ogq @thm_overlay_0 "#36a3d9"
          set -ogq @thm_surface_2 "#253340"
          set -ogq @thm_surface_1 "#253340"
          set -ogq @thm_surface_0 "#253340"
          set -ogq @thm_mantle "#0f1419"
          set -ogq @thm_crust "#000000"
        EOF
      '';
    })
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
    tmux
    sesh
    fzf
  ];

  buildInputs = [ makeWrapper ];
  postBuild = ''
    mkdir $out/tmux
    echo 

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

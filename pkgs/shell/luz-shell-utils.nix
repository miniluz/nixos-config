{
  symlinkJoin,
  pkgs,
  miniluz-pkgs,
}:
symlinkJoin {
  name = "luz-shell-utils";
  paths =
    (with pkgs; [
      uutils-coreutils-noprefix
      file
      parted
      trashy
      p7zip
      pciutils
      usbutils

      # These do not cost anything because Yazi includes them
      poppler-utils
      imagemagick
      resvg
      chafa

      tealdeer # tldr
      navi # command templates

      nmap # port map
      dig.dnsutils # dns
      dogedns
      mtr # real time tracing
      curl
      wget

      wiki-tui
      porsmo

      procs # processes
      bat
      glow # pretty markdown
      eza
      zoxide
      delta

      serpl # find replace
      fzf
      ripgrep
      fd

      dust
      dua

      direnv
      hyperfine
      kondo # clean project dirs
      gh
      lazydocker
      entr # run something on reload
      gitlogue

      claude-code
    ])
    ++ (with miniluz-pkgs; [
      luz-neovim

      git-randomize-commit-times
      git-clean-branches

      luznix-shell-setup
      bg-run

      git-luzwrap
      jj-luzwrap
      btop-luzwrap
      gitui-luzwrap
      tmux-luzwrap
      yazi-luzwrap
    ]);
}

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

      tealdeer # tldr
      navi # command templates

      nmap # port map
      dig.dnsutils # dns
      dogedns
      termshark # wireshark
      mtr # real time tracing
      curl
      wget

      evil-helix

      wiki-tui
      porsmo

      procs # processes
      bat
      glow # pretty markdown
      eza
      zoxide
      delta
      yazi

      serpl # find replace
      fzf
      ripgrep
      ripgrep-all
      fd

      dust
      dua

      direnv
      hyperfine
      kondo # clean project dirs
      gh
      lazydocker
      entr # run something on reload

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
      zellij-luzwrap
      tmux-luzwrap
    ]);
}

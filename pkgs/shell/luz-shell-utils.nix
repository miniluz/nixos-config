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

      procs
      bat
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
      kondo
      gh
      lazydocker

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

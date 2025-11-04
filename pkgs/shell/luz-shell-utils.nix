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
      nmap
      dig.dnsutils
      dogdns
      parted
      curl
      wget
      termshark
      pciutils
      usbutils

      evil-helix

      wiki-tui
      tealdeer
      porsmo
      p7zip
      trashy

      bat
      eza
      zoxide
      delta
      yazi

      fzf
      ripgrep
      ripgrep-all
      fd
      dust
      dua

      direnv
      devenv
      hyperfine
      kondo
      comma
      gh
      lazyjj

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

{
  symlinkJoin,
  luz-neovim-unwrapped,
  nixd,
  nixfmt-rfc-style,
  wl-clipboard,
  wl-clipboard-x11,
  jq,
  yq,
}:
symlinkJoin {
  name = "luz-neovim";
  paths = [
    luz-neovim-unwrapped
    nixd
    nixfmt-rfc-style
    wl-clipboard
    wl-clipboard-x11
    jq
    yq
  ];

  meta.mainProgram = "nvim";
}

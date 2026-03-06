{
  yazi,

  yaziPlugins,

  jq,
  poppler-utils,
  _7zz,
  fd,
  ripgrep,
  fzf,
  zoxide,
  imagemagick,
  chafa,
  resvg,

  lib,

}:
yazi.override {

  settings = {
    yazi = lib.importTOML ./yazi.toml;
    keymaps = lib.importTOML ./yazi-keymaps.toml;
  };

  initLua = ./yazi-init.lua;

  plugins = {
    inherit (yaziPlugins)
      git
      bypass
      chmod
      glow
      relative-motions
      smart-filter
      compress
      ;
  };

  optionalDeps = [
    jq
    poppler-utils
    _7zz
    fd
    ripgrep
    fzf
    zoxide
    imagemagick
    chafa
    resvg
  ];
}

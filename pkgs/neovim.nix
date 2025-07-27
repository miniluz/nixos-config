{ inputs, pkgs, ... }:
(inputs.nvf.lib.neovimConfiguration {
  pkgs = pkgs;
  modules = [ ../nvim/nvim.nix ];
}).neovim

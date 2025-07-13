{ pkgs, lib, ... }:
{
  config.vim = {
    comments.comment-nvim = {
      enable = true;
      setupOpts = {
        pre_hook = lib.generators.mkLuaInline ''require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()'';
      };
    };

    extraPlugins.ts-context-commentstring = {
      package = pkgs.vimPlugins.nvim-ts-context-commentstring;

      setup = ''
        require('ts_context_commentstring').setup({});
      '';
    };
  };
}

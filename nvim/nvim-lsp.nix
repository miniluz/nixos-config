{
  config.vim = {
    treesitter.enable = true;

    lsp = {
      enable = true;
      formatOnSave = true;
      inlayHints.enable = true;
      trouble.enable = true;

      lspsaga.enable = true;
    };

    diagnostics = {
      enable = true;
      nvim-lint.enable = true;
      config.virtual_text = true;
    };

    languages = {
      enableTreesitter = true;
      enableFormat = true;
      enableDAP = true;
    };

    formatter.conform-nvim.enable = true;

    snippets.luasnip.enable = true;

    debugger.nvim-dap = {
      enable = true;
      ui.enable = true;
    };

  };
}

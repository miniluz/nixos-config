{
  config.vim = {
    treesitter.enable = true;

    lsp = {
      enable = true;
      formatOnSave = true;
      inlayHints.enable = true;
      lspSignature.enable = true;

      lightbulb.enable = true;
      lspkind.enable = true;
      nvim-docs-view.enable = true;
      otter-nvim.enable = true;
      trouble.enable = true;

      mappings = {
        listDocumentSymbols = null;
        signatureHelp = "<leader>lx";
      };
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
      enableExtraDiagnostics = true;
    };

    formatter.conform-nvim.enable = true;

    snippets.luasnip.enable = true;

    debugger.nvim-dap = {
      enable = true;
      ui.enable = true;
    };

  };
}

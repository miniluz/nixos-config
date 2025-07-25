{
  pkgs,
  ...
}:
let
  js-i18n-source = pkgs.fetchFromGitHub {
    name = "js-i18n.nvim";
    owner = "nabekou29";
    repo = "js-i18n.nvim";
    rev = "5157a1c1a47b14aa77fa6e50626dc1add4d1a618";
    hash = "sha256-dgOSKnRB4jJQMgycRrnnaa12HtHxU3F3v99d/8743SM=";
  };
  js-i18n = pkgs.vimUtils.buildVimPlugin {
    pname = "js-i18n.nvim";
    version = "2025-07-24";
    src = js-i18n-source;

    dependencies = with pkgs.vimPlugins; [
      nvim-lspconfig
      nvim-treesitter
      plenary-nvim
    ];
  };
  keymap = key: desc: action: {
    inherit key action desc;
    mode = [ "n" ];
    silent = true;
  };
  luaKeymap = key: desc: action: {
    inherit key action;
    mode = [ "n" ];
    silent = true;
    lua = true;
  };
  luaLanguageList = ''{"en", "es"}'';
in
{
  config.vim = {
    lazy.plugins = {
      "js-i18n.nvim" = {
        package = js-i18n;
        setupModule = "js-i18n";
        event = [
          "BufReadPre"
          "BufNewFile"
        ];

        keys = [
          (keymap "<leader>itv" "Toggle i18n virtual text" "<cmd>I18nVirtualTextToggle<CR>")
          (keymap "<leader>itd" "Toggle i18n diagnostics" "<cmd>I18nDiagnosticToggle<CR>")
          (luaKeymap "<leader>il" "Select i18n language" ''
            vim.ui.select(
              ${luaLanguageList},
              { prompt = "Select i18n language:" },
              function(choice)
                if choice then
                  vim.cmd("I18nSetLang " .. choice)
                end
              end
            )
          '')
          (keymap "<leader>ig" "Go to (or create) translation" "<cmd>I18nEditTranslation<CR>")
          (luaKeymap "<leader>iG" "Go to (or create) translation in a language" ''
            vim.ui.select(
              ${luaLanguageList},
              { prompt = "Select i18n language:" },
              function(choice)
                if choice then
                  vim.cmd("I18nEditTranslation" .. choice)
                end
              end
            )
          '')
        ];
      };
    };
  };
}

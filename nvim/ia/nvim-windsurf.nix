{ pkgs, ... }:
{
  config.vim = {
    lazy.plugins."windsurf.nvim" = {
      package = pkgs.vimPlugins.windsurf-nvim;

      setupModule = "codeium";

      lazy = false;

      setupOpts = {
        enable_cmp_source = false;

        virtual_text = {
          enabled = true;
          manual = false;
          filetypes = { };
          default_filetype_enabled = true;
          idle_delay = 75;
          virtual_text_priority = 65535;
          map_keys = true;
          key_bindings = {
            accept = "<C-Enter>";
            accept_word = false;
            accept_line = false;
            clear = "<C-Backspace>";
            next = "<M-]>";
            prev = "<M-[>";
          };
        };
      };
    };
  };
}

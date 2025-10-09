{
  config.vim = {
    languages = {
      bash.enable = true;
      css = {
        enable = true;
        format.type = "prettierd";
      };
      html.enable = true;
      python.enable = true;
      yaml.enable = true;
      lua.enable = true;
      sql.enable = true;
      nu.enable = true;
      markdown = {
        enable = true;
        extensions.markview-nvim = {
          enable = true;
          setupOpts.preview = {
            filetypes = [
              "markdown"
              "quarto"
              "rmd"
              "typst"
              "CodeCompanion"
            ];
            modes = [
              "i"
              "n"
              "no"
              "c"
            ];
            hybrid_modes = [
              "i"
              "n"
              "no"
              "c"
            ];
          };
        };
      };
    };
  };
}

{
  config.vim = {
    languages = {
      ts = {
        enable = true;
        format.enable = true;
        format.type = "prettier";
        extensions.ts-error-translator.enable = true;
      };
      tailwind.enable = true;
      css.enable = true;
      html.enable = true;
    };
  };
}

{ lib, ... }:
{
  config.vim = {
    mini = {
      ai.enable = true;
      move.enable = true;

      surround.enable = true;

      basics = {
        enable = true;
        setupOpts = {
          mappings = {
            windows = true;
            move_with_alt = true;
          };
        };
      };

      bracketed.enable = true;
      diff.enable = true;
      extra.enable = true;
      git.enable = true;

      hipatterns = {
        enable = true;
        setupOpts = {
          hex_color = lib.generators.mkLuaInline ''hipatterns.gen_highlighter.hex_color()'';
        };
      };
    };
  };
}

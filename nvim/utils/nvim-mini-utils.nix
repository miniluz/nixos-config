{ lib, ... }:
{
  config.vim = {
    mini = {
      ai.enable = true;
      move.enable = true;

      surround.enable = true;

      basics.enable = true;
      bracketed.enable = true;
      diff.enable = true;
      extra.enable = true;
      git.enable = true;

      colors.enable = true;
      indentscope = {
        enable = true;
        setupOpts = {
          symbol = "|";
          draw = {
            delay = 20;
            animation = lib.generators.mkLuaInline ''
              function(s,n) return 10 end
            '';
          };
        };
      };
    };
  };
}

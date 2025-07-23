{
  lib,
  ...
}:
{
  config.vim = {
    assistant.codecompanion-nvim = {
      enable = true;
      setupOpts = {
        adapters = lib.generators.mkLuaInline ''
          {
            gemini = function()
              return require("codecompanion.adapters").extend("gemini", {
                env = {
                  api_key = "cmd:cat /etc/google-ai-lab"
                },
                -- schema = {
                --  model = {
                --    choices = {
                --      ["gemini-2.5-flash-lite"] = { opts = { can_reason = true }}
                --    },
                --  },
                --},
              })
            end, 
          }
        '';

        strategies = {
          chat = {
            adapter = "gemini";
          };
          inline = {
            adapter = "gemini";
            # model = "gemini-2.5-flash-lite";
          };
        };
      };
    };
  };
}

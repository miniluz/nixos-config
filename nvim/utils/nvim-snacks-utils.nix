{
  config.vim = {
    luaConfigRC.snacks-utils = ''
      vim.ui.input = Snacks.input;

      local prev = { new_name = "", old_name = "" } -- Prevents duplicate events
      vim.api.nvim_create_autocmd("User", {
        pattern = "NvimTreeSetup",
        callback = function()
          local events = require("nvim-tree.api").events
          events.subscribe(events.Event.NodeRenamed, function(data)
            if prev.new_name ~= data.new_name or prev.old_name ~= data.old_name then
              data = data
              Snacks.rename.on_rename_file(data.old_name, data.new_name)
            end
          end)
        end,
      })

      vim.api.nvim_set_hl(0, "SnacksIndent", { fg = "#363a4f" })
      vim.api.nvim_set_hl(0, "SnacksIndentScope", { fg = "#5b6078" })
    '';

    utility.snacks-nvim = {
      enable = true;
      setupOpts = {
        bigfile.enabled = true;
        indent = {
          enabled = true;
          symbol = "┊";
        };
        input.enabled = true;
        rename.enabled = true;
        notifier.enabled = true;
        quickfile.enabled = true;
        words.enabled = true;
      };
    };
  };
}

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
    '';

    utility.snacks-nvim = {
      enable = true;
      setupOpts = {
        bigfile.enabled = true;
        indent.enabled = true;
        input.enabled = true;
        rename.enabled = true;
        notifier.enabled = true;
        quickfile.enabled = true;
        words.enabled = true;
      };
    };
  };
}

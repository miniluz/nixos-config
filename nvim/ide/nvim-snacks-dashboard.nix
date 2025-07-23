{
  lib,
  ...
}:
{
  config.vim = {
    autocmds = [
      {
        event = [ "VimEnter" ];
        callback = lib.generators.mkLuaInline ''
          function()
            if vim.fn.argc() == 0 then
              Snacks.dashboard();
            end
          end
        '';
        desc = "Snacks dashboard on VimEnter";
        group = "OpenSnacksDashboard";
      }
    ];

    utility.snacks-nvim = {
      enable = true;
      setupOpts.dashboard = {
        enable = true;
        keys = lib.generators.mkLuaInline ''
          {
            { icon = " "; key = "f"; desc = "Find File"; action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " "; key = "n"; desc = "New File"; action = ":ene | startinsert" },
            { icon = " "; key = "g"; desc = "Find Text"; action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " "; key = "r"; desc = "Recent Files"; action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = " "; key = "c"; desc = "Config"; action = ":lua Snacks.dashboard.pick('files', {cwd = os.getenv(\"NH_FLAKE\")})" },
            { icon = " "; key = "q"; desc = "Quit"; action = ":qa" },
          }
        '';
        sections = [
          { section = "header"; }
          {
            section = "keys";
            gap = 1;
            padding = 1;
          }
          {
            icon = " ";
            title = "Recent Files";
            section = "recent_files";
            indent = 2;
            padding = 1;
          }
          {
            icon = " ";
            title = "Projects";
            section = "projects";
            indent = 2;
            padding = 1;
          }
        ];
      };
    };
  };
}

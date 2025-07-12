{
  config.vim = {
    telescope.enable = true;

    utility.snacks-nvim = {
      enable = true;
      setupOpts = {
        bigfile = {
          enabled = true;
        };
        dashboard = {
          enabled = true;
        };
        explorer = {
          enabled = true;
          auto_close = true;
          toggles = true;
        };
        indent = {
          enabled = true;
        };
        input = {
          enabled = true;
        };
        notifier = {
          enabled = true;
          timeout = 3000;
        };
        picker = {
          enabled = true;
        };
        quickfile = {
          enabled = true;
        };
        scope = {
          enabled = true;
        };
        scroll = {
          enabled = true;
        };
        statuscolumn = {
          enabled = true;
        };
        words = {
          enabled = true;
        };
      };
    };

    luaConfigPost = "vim.ui.select = Snacks.picker.select;";

    keymaps = [
      # top pickers and explorer
      {
        key = "<leader><space>";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.picker.smart() end'';
        desc = "Smart Find Files";
      }
      {
        key = "<leader>,";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.picker.buffers() end'';
        desc = "Buffers";
      }
      {
        key = "<leader>/";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.picker.grep() end'';
        desc = "Grep";
      }
      {
        key = "<leader>:";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.picker.command_history() end'';
        desc = "Command History";
      }
      {
        key = "<leader>n";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.picker.notifications() end'';
        desc = "Notification History";
      }
      {
        key = "<leader>e";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.explorer() end'';
        desc = "File Explorer";
      }
      # find
      {
        key = "<leader>fb";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.picker.buffers() end'';
        desc = "Buffers";
      }
      {
        key = "<leader>fc";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end'';
        desc = "Find Config File";
      }
      {
        key = "<leader>ff";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.picker.files() end'';
        desc = "Find Files";
      }
      {
        key = "<leader>fg";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.picker.git_files() end'';
        desc = "Find Git Files";
      }
      {
        key = "<leader>fp";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.picker.projects() end'';
        desc = "Projects";
      }
      {
        key = "<leader>fr";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.picker.recent() end'';
        desc = "Recent";
      }
      # git
      {
        key = "<leader>gb";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.picker.git_branches() end'';
        desc = "Git Branches";
      }
      {
        key = "<leader>gl";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.picker.git_log() end'';
        desc = "Git Log";
      }
      {
        key = "<leader>gL";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.picker.git_log_line() end'';
        desc = "Git Log Line";
      }
      {
        key = "<leader>gs";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.picker.git_status() end'';
        desc = "Git Status";
      }
      {
        key = "<leader>gS";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.picker.git_stash() end'';
        desc = "Git Stash";
      }
      {
        key = "<leader>gd";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.picker.git_diff() end'';
        desc = "Git Diff (Hunks)";
      }
      {
        key = "<leader>gf";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.picker.git_log_file() end'';
        desc = "Git Log File";
      }
      # Grep
      {
        key = "<leader>sb";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.picker.lines() end'';
        desc = "Buffer Lines";
      }
      {
        key = "<leader>sB";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.picker.grep_buffers() end'';
        desc = "Grep Open Buffers";
      }
      {
        key = "<leader>sg";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.picker.grep() end'';
        desc = "Grep";
      }
      {
        key = "<leader>sw";
        mode = [
          "n"
          "x"
        ];
        silent = true;
        lua = true;
        action = ''function() Snacks.picker.grep_word() end'';
        desc = "Visual selection or word";
      }
      # search
      {
        key = "<leader>s\"";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.picker.registers() end'';
        desc = "Registers";
      }
      {
        key = "<leader>s/";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.picker.search_history() end'';
        desc = "Search History";
      }
      {
        key = "<leader>sa";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.picker.autocmds() end'';
        desc = "Autocmds";
      }
      {
        key = "<leader>sb";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.picker.lines() end'';
        desc = "Buffer Lines";
      }
      {
        key = "<leader>sc";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.picker.command_history() end'';
        desc = "Command History";
      }
      {
        key = "<leader>sC";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.picker.commands() end'';
        desc = "Commands";
      }
      {
        key = "<leader>sd";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.picker.diagnostics() end'';
        desc = "Diagnostics";
      }
      {
        key = "<leader>sD";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.picker.diagnostics_buffer() end'';
        desc = "Buffer Diagnostics";
      }
      {
        key = "<leader>sh";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.picker.help() end'';
        desc = "Help Pages";
      }
      {
        key = "<leader>sH";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.picker.highlights() end'';
        desc = "Highlights";
      }
      {
        key = "<leader>si";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.picker.icons() end'';
        desc = "Icons";
      }
      {
        key = "<leader>sj";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.picker.jumps() end'';
        desc = "Jumps";
      }
      {
        key = "<leader>sk";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.picker.keymaps() end'';
        desc = "Keymaps";
      }
      {
        key = "<leader>sl";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.picker.loclist() end'';
        desc = "Location List";
      }
      {
        key = "<leader>sm";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.picker.marks() end'';
        desc = "Marks";
      }
      {
        key = "<leader>sM";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.picker.man() end'';
        desc = "Man Pages";
      }
      {
        key = "<leader>sp";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.picker.lazy() end'';
        desc = "Search for Plugin Spec";
      }
      {
        key = "<leader>sq";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.picker.qflist() end'';
        desc = "Quickfix List";
      }
      {
        key = "<leader>sR";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.picker.resume() end'';
        desc = "Resume";
      }
      {
        key = "<leader>su";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.picker.undo() end'';
        desc = "Undo History";
      }
      {
        key = "<leader>uC";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.picker.colorschemes() end'';
        desc = "Colorschemes";
      }
      # LSP
      {
        key = "gd";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.picker.lsp_definitions() end'';
        desc = "Goto Definition";
      }
      {
        key = "gD";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.picker.lsp_declarations() end'';
        desc = "Goto Declaration";
      }
      {
        key = "gr";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.picker.lsp_references() end'';
        desc = "References";
      }
      {
        key = "gI";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.picker.lsp_implementations() end'';
        desc = "Goto Implementation";
      }
      {
        key = "gy";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.picker.lsp_type_definitions() end'';
        desc = "Goto T[y]pe Definition";
      }
      {
        key = "<leader>ss";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.picker.lsp_symbols() end'';
        desc = "LSP Symbols";
      }
      {
        key = "<leader>sS";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.picker.lsp_workspace_symbols() end'';
        desc = "LSP Workspace Symbols";
      }
      # Other
      {
        key = "<leader>z";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.zen() end'';
        desc = "Toggle Zen Mode";
      }
      {
        key = "<leader>Z";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.zen.zoom() end'';
        desc = "Toggle Zoom";
      }
      {
        key = "<leader>.";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.scratch() end'';
        desc = "Toggle Scratch Buffer";
      }
      {
        key = "<leader>S";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.scratch.select() end'';
        desc = "Select Scratch Buffer";
      }
      {
        key = "<leader>n";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.notifier.show_history() end'';
        desc = "Notification History";
      }
      {
        key = "<leader>bd";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.bufdelete() end'';
        desc = "Delete Buffer";
      }
      {
        key = "<leader>cR";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.rename.rename_file() end'';
        desc = "Rename File";
      }
      {
        key = "<leader>gB";
        mode = [
          "n"
          "v"
        ];
        silent = true;
        lua = true;
        action = ''function() Snacks.gitbrowse() end'';
        desc = "Git Browse";
      }
      {
        key = "<leader>gg";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.lazygit() end'';
        desc = "Lazygit";
      }
      {
        key = "<leader>un";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.notifier.hide() end'';
        desc = "Dismiss All Notifications";
      }
      {
        key = "<c-/>";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.terminal() end'';
        desc = "Toggle Terminal";
      }
      {
        key = "<c-_>";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.terminal() end'';
        desc = "which_key_ignore";
      }
      {
        key = "]]";
        mode = [
          "n"
          "t"
        ];
        silent = true;
        lua = true;
        action = ''function() Snacks.words.jump(vim.v.count1) end'';
        desc = "Next Reference";
      }
      {
        key = "[[";
        mode = [
          "n"
          "t"
        ];
        silent = true;
        lua = true;
        action = ''function() Snacks.words.jump(-vim.v.count1) end'';
        desc = "Prev Reference";
      }
    ];
  };
}

{
  config.vim = {
    telescope.enable = true;

    utility.snacks-nvim = {
      enable = true;
      setupOpts.picker.enabled = true;
    };

    luaConfigRC.snacks-picker = "vim.ui.select = Snacks.picker.select;";

    keymaps = [
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
        key = "<leader>n";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.picker.notifications() end'';
        desc = "Notification History";
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
        key = "<C-S-p>";
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
        key = "<leader>ls";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.picker.lsp_symbols() end'';
        desc = "LSP Symbols";
      }
      {
        key = "<leader>lS";
        mode = "n";
        silent = true;
        lua = true;
        action = ''function() Snacks.picker.lsp_workspace_symbols() end'';
        desc = "LSP Workspace Symbols";
      }
    ];
  };
}

{
  config.vim = {
    keymaps = [
      {
        key = "<leader>tf";
        mode = [ "n" ];
        silent = true;
        lua = true;
        action = ''
          function()
            if vim.g.neovide_fullscreen == nil then
              vim.g.neovide_fullscreen = true
            else
              vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
            end
          end
        '';
        desc = "Toggle Neovide Fullscreen";
      }
    ];
  };
}

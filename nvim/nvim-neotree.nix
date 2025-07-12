{ lib, ... }:
{
  config.vim = {
    filetree.neo-tree = {
      enable = true;
      setupOpts = {
        event_handlers = {
          event = "file_opened";
          handler = lib.generators.mkLuaInline ''
            function(file_path)
              vimc.cmd("Neotree close");
            end
          '';
        };
      };
    };
    keymaps = [
      {
        key = "<leader>e";
        mode = [
          "n"
          "v"
        ];
        silent = true;
        action = "<cmd>Neotree toggle right<cr>";
      }
    ];
  };

}

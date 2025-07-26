{
  pkgs,
  lib,
  ...
}:
let
  nvim-copy-source = pkgs.fetchFromGitHub {
    name = "nvim-copy";
    owner = "YounesElhjouji";
    repo = "nvim-copy";
    rev = "529fe4820c912c92f2d725e0c2a624063dd3d516";
    hash = "sha256-5B8hD8cheiOUHrweWes5sHk3Ok93f9Yas7y48caTBkU=";
  };
  nvim-copy = pkgs.vimUtils.buildVimPlugin {
    pname = "nvim-copy";
    version = "2025-07-26";
    src = nvim-copy-source;
  };
in
{
  config.vim = {
    git.enable = true;

    autocomplete.nvim-cmp.enable = true;

    binds.whichKey.enable = true;
    binds.hardtime-nvim.enable = true;

    utility = {
      # undotree.enable = true;
      direnv.enable = true;
      motion.leap.enable = true;
    };

    visuals.fidget-nvim.enable = true;

    statusline.lualine.enable = true;

    projects.project-nvim.enable = true;

    notes.todo-comments.enable = true;

    autopairs.nvim-autopairs.enable = true;

    ui.noice.enable = true;

    navigation.harpoon.enable = true;

    options = {
      foldcolumn = "1";
      foldlevel = 99;
      foldlevelstart = 99;
      foldenable = true;
    };

    ui.nvim-ufo = {
      enable = true;
      setupOpts.providerSelector = lib.generators.mkLuaInline ''
        function(bufnr, filetype, buftype)
          return { "treesitter", "indent" }
        end
      '';
    };

    lazy.plugins = {
      "guess-indent.nvim" = {
        package = pkgs.vimPlugins.guess-indent-nvim;
        setupModule = "guess-indent";
      };
      "nvim-copy" = {
        package = nvim-copy;
        setupModule = "nvim_copy";
        setupOpts = {
          ignore = [
            "*node_modules/*"
            "*.git/*"
            "*dist/*"
            "*build/*"
            "*target/*"
            "*result/*"
          ];
        };
        cmd = [
          "CopyBuffersToClipboard"
          "CopyCurrentBufferToClipboard"
          "CopyGitFilesToClipboard"
          "CopyQuickfixFilesToClipboard"
          "CopyHarpoonFilesToClipboard"
        ];
      };
      "nvim-spider" = {
        package = pkgs.vimPlugins.nvim-spider;
        setupModule = "spider";
        lazy = false;
        keys = [
          {
            key = "w";
            action = "<cmd>lua require('spider').motion('w')<CR>";
            mode = [
              "n"
              "o"
              "x"
            ];
            silent = true;
          }
          {
            key = "e";
            action = "<cmd>lua require('spider').motion('e')<CR>";
            mode = [
              "n"
              "o"
              "x"
            ];
            silent = true;
          }
          {
            key = "b";
            action = "<cmd>lua require('spider').motion('b')<CR>";
            mode = [
              "n"
              "o"
              "x"
            ];
            silent = true;
          }
        ];
      };
    };
  };
}

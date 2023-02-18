{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.vim.neoclip;
in
{
  options.vim.neoclip = {
    enable = mkEnableOption "Enable nvim-neoclip.lua plugin";
  };

  config = mkIf cfg.enable {
    vim.startPlugins = [ pkgs.neovimPlugins.nvim-neoclip ];

    vim.nnoremap = {
      "<leader>nc" = "<cmd> Telescope neoclip unnamed extra=star,plus<CR>";
    };

    vim.luaConfigRC = ''
      require('neoclip').setup({
        history = 200,
        enable_persistent_history = false,
        length_limit = 1048576,
        continuous_sync = false,
        db_path = vim.fn.stdpath("data") .. "/databases/neoclip.sqlite3",
        filter = nil,
        preview = true,
        prompt = nil,
        default_register = '"',
        default_register_macros = 'q',
        enable_macro_history = true,
        content_spec_column = false,
        on_select = {
          move_to_front = false,
          close_telescope = true,
        },
        on_paste = {
          set_reg = false,
          move_to_front = false,
          close_telescope = true,
        },
        on_replay = {
          set_reg = false,
          move_to_front = false,
          close_telescope = true,
        },
        on_custom_action = {
          close_telescope = true,
        },
        keys = {
          telescope = {
            i = {
              select = '<cr>',
              paste = '<c-p>',
              paste_behind = '<c-k>',
              replay = '<c-q>',  -- replay a macro
              delete = '<c-d>',  -- delete an entry
              edit = '<c-e>',  -- edit an entry
              custom = {},
            },
            n = {
              select = '<cr>',
              paste = 'p',
              --- It is possible to map to more than one key.
              -- paste = { 'p', '<c-p>' },
              paste_behind = 'P',
              replay = 'q',
              delete = 'd',
              edit = 'e',
              custom = {},
            },
          },
          fzf = {
            select = 'default',
            paste = 'ctrl-p',
            paste_behind = 'ctrl-k',
            custom = {},
          },
        },
      })

      ${writeIf config.vim.telescope.enable ''
        require('telescope').load_extension('neoclip')
      ''}
    '';
  };
}

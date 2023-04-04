{ pkgs, config, lib, ... }:

with lib;
with builtins;

let
  cfg = config.vim.treesitter;
in
{
  options.vim.treesitter = {
    enable = mkOption {
      type = types.bool;
      description = "enable tree-sitter [nvim-treesitter]";
    };

    fold = mkOption {
      type = types.bool;
      description = "enable fold with tree-sitter";
    };

    autotagHtml = mkOption {
      type = types.bool;
      description = "enable autoclose and rename html tag [nvim-ts-autotag]";
    };

    textobjects = mkOption {
      type = types.bool;
      description = "enable nvim-treesitter-textobjects and its default configuration";
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins = with pkgs.neovimPlugins; (
      [ nvim-treesitter ] ++
      (withPlugins cfg.autotagHtml [ nvim-ts-autotag ]) ++
      (withPlugins cfg.textobjects [ nvim-treesitter-textobjects ])
    );

    vim.configRC = writeIf (cfg.fold && !config.vim.lsp.folds) ''
      " Tree-sitter based folding
      set foldmethod=expr
      set foldexpr=nvim_treesitter#foldexpr()
    '';

    vim.luaConfigRC =
      ''
        -- Treesitter config
        require'nvim-treesitter.configs'.setup {
          highlight = {
            enable = true,
          },

          incremental_selection = {
            enable = true,
            keymaps = {
              init_selection = "gnn",
              node_incremental = "grn",
              scope_incremental = "grc",
              node_decremental = "grm",
            },
          },

          indent = {
            enable = true,
          },

          ${writeIf cfg.textobjects ''
          textobjects = {
            enable = true,
            swap = {
              enable = true,
              swap_next = {
                ["<leader>la"] = "@parameter.inner",
              },
              swap_previous = {
                ["<leader>lA"] = "@parameter.inner",
              },
            },
            select = {
              enable = true,
              lookahead = true,
              keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
                ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
              },
              selection_modes = {
                ['@parameter.outer'] = 'v', -- charwise
                ['@function.outer'] = 'V',  -- linewise
                ['@class.outer'] = '<c-v>', -- blockwise
              },
              include_surrounding_whitespace = true,
            },
          },
          ''}

          ${writeIf cfg.autotagHtml ''
          autotag = {
            enable = true,
          },
          ''}
        }
      '';
  };
}

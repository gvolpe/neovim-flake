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
  };

  config = mkIf cfg.enable (
    let
      disabledLanguages =
        if (config.vim.scala.highlightMode == "regex")
        then ''{ "scala" }''
        else "{}";
    in
    {
      vim.startPlugins = with pkgs.neovimPlugins; (
        [ nvim-treesitter ] ++ (withPlugins cfg.autotagHtml [ nvim-ts-autotag ])
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
            autotag = {
              enable = true,
              disable = ${disabledLanguages},
            },

            highlight = {
              enable = true,
              disable = ${disabledLanguages},
            },

            incremental_selection = {
              enable = true,
              disable = ${disabledLanguages},
              keymaps = {
                init_selection = "gnn",
                node_incremental = "grn",
                scope_incremental = "grc",
                node_decremental = "grm",
              },
            },

            indent = {
              enable = false,
              disable = ${disabledLanguages},
            },

            ${writeIf cfg.autotagHtml ''
            autotag = {
              enable = true,
            },
          ''}
          }
        '';
    }
  );
}

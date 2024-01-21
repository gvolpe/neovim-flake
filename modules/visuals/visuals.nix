{ pkgs, config, lib, ... }:

with lib;
with builtins;

let
  cfg = config.vim.visuals;
in
{
  options.vim.visuals = {
    enable = mkOption {
      type = types.bool;
      description = "visual enhancements";
    };

    nvimWebDevicons.enable = mkOption {
      type = types.bool;
      description = "enable dev icons. required for certain plugins [nvim-web-devicons]";
    };

    lspkind.enable = mkOption {
      type = types.bool;
      description = "enable vscode-like pictograms for lsp [lspkind]";
    };

    cursorWordline = {
      enable = mkOption {
        type = types.bool;
        description = "enable word and delayed line highlight [nvim-cursorline]";
      };

      lineTimeout = mkOption {
        type = types.int;
        description = "time in milliseconds for cursorline to appear";
      };
    };

    indentBlankline = {
      enable = mkOption {
        type = types.bool;
        description = "enable indentation guides [indent-blankline]";
      };

      listChar = mkOption {
        type = types.str;
        description = "Character for indentation line";
      };

      fillChar = mkOption {
        type = types.str;
        description = "Character to fill indents";
      };

      eolChar = mkOption {
        type = types.str;
        description = "Character at end of line";
      };

      showCurrContext = mkOption {
        type = types.bool;
        description = "Highlight current context from treesitter";
      };
    };
  };

  config = mkIf cfg.enable
    {
      vim.startPlugins = with pkgs.neovimPlugins; (
        (withPlugins cfg.nvimWebDevicons.enable [ nvim-web-devicons ]) ++
        (withPlugins cfg.lspkind.enable [ lspkind ]) ++
        (withPlugins cfg.cursorWordline.enable [ nvim-cursorline ]) ++
        (withPlugins cfg.indentBlankline.enable [ indent-blankline ])
      );

      vim.luaConfigRC = ''
        ${writeIf cfg.lspkind.enable "require'lspkind'.init()"}

        ${writeIf cfg.indentBlankline.enable ''
            -- highlight error: https://github.com/lukas-reineke/indent-blankline.nvim/issues/59
            vim.wo.colorcolumn = "99999"
            vim.opt.list = true

            ${writeIf (cfg.indentBlankline.eolChar != "") ''
                vim.opt.listchars:append({ eol = "${cfg.indentBlankline.eolChar}" })
              ''
            }

            ${writeIf (cfg.indentBlankline.fillChar != "") ''
                vim.opt.listchars:append({ space = "${cfg.indentBlankline.fillChar}"})
              ''
            }

            require("ibl").setup {
              scope = {
                enabled = true;
                char = "${cfg.indentBlankline.listChar}",
                injected_languages = ${boolToString cfg.indentBlankline.showCurrContext},
                show_end = true,
              }
            }
          ''
        }

        ${writeIf cfg.cursorWordline.enable ''
            vim.g.cursorline_timeout = ${toString cfg.cursorWordline.lineTimeout}
          ''
        }
      '';
    };
}

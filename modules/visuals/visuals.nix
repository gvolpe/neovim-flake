{ pkgs, config, lib, ... }:

with lib;
with builtins;

let
  cfg = config.vim.visuals;
  keys = config.vim.keys.whichKey;
in
{
  options.vim.visuals = {
    enable = mkOption {
      type = types.bool;
      description = "visual enhancements";
    };

    noice.enable = mkOption {
      type = types.bool;
      description = "enable the noice plugin";
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
        (withPlugins cfg.noice.enable [ noice nui-nvim ]) ++
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

        ${writeIf cfg.noice.enable ''
            ${writeIf keys.enable ''
              wk.register({
                ["<leader>n"] = {
                  name = "Noice",
                  d = { "<cmd> NoiceDismiss <CR>", "Dismiss notifications" },
                },
              })
            ''}

            require("noice").setup({
              cmdline = {
                enabled = true, -- enables the Noice cmdline UI
                view = "cmdline_popup", -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
                opts = {}, -- global options for the cmdline. See section on views
                format = {
                  cmdline = { pattern = "^:", icon = "", lang = "vim" },
                  search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
                  search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
                  filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
                  lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
                  help = { pattern = "^:%s*he?l?p?%s+", icon = "" },
                  input = {}, -- Used by input()
                },
              },
              messages = {
                enabled = false, -- enables the Noice messages UI
                view = "notify", -- default view for messages
                view_error = "notify", -- view for errors
                view_warn = "notify", -- view for warnings
                view_history = "messages", -- view for :messages
                view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
              },
              popupmenu = {
                enabled = true, -- enables the Noice popupmenu UI
                backend = "nui", -- backend to use to show regular cmdline completions
                kind_icons = {}, -- set to `false` to disable icons
              },
              views = {
                notify = {
                  replace = true,
                },
              },
              lsp = {
                progress = {
                  enabled = true,
                  format = "lsp_progress",
                  format_done = "lsp_progress_done",
                  throttle = 1000 / 30, -- frequency to update lsp progress message
                  view = "notify",
                },
                override = {
                  ["vim.lsp.util.convert_input_to_markdown_lines"] = false,
                  ["vim.lsp.util.stylize_markdown"] = false,
                  ["cmp.entry.get_documentation"] = false,
                },
                hover = {
                  enabled = true,
                  silent = false, -- set to true to not show a message if hover is not available
                  view = nil, -- when nil, use defaults from documentation
                  opts = {}, -- merged with defaults from documentation
                },
                signature = {
                  enabled = false,
                  auto_open = {
                    enabled = true,
                    trigger = true, -- Automatically show signature help when typing a trigger character from the LSP
                    luasnip = true, -- Will open signature help when jumping to Luasnip insert nodes
                    throttle = 50, -- Debounce lsp signature help request by 50ms
                  },
                  view = nil, -- when nil, use defaults from documentation
                  opts = {}, -- merged with defaults from documentation
                },
                message = {
                  enabled = true,
                  view = "notify",
                  opts = {},
                },
                documentation = {
                  view = "hover",
                  opts = {
                    lang = "markdown",
                    replace = true,
                    render = "plain",
                    format = { "{message}" },
                    win_options = { concealcursor = "n", conceallevel = 3 },
                  },
                },
              },
              markdown = {
                hover = {
                  ["|(%S-)|"] = vim.cmd.help, -- vim help links
                  ["%[.-%]%((%S-)%)"] = require("noice.util").open, -- markdown links
                },
                highlights = {
                  ["|%S-|"] = "@text.reference",
                  ["@%S+"] = "@parameter",
                  ["^%s*(Parameters:)"] = "@text.title",
                  ["^%s*(Return:)"] = "@text.title",
                  ["^%s*(See also:)"] = "@text.title",
                  ["{%S-}"] = "@parameter",
                },
              },
            })
          ''
        }
      '';
    };
}

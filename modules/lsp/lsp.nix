{ pkgs, config, lib, ... }:

with lib;
with builtins;

let
  cfg = config.vim.lsp;
  keys = config.vim.keys.whichKey;

  metalsServerProperties =
    let str = builtins.toJSON cfg.scala.metals.serverProperties;
    in lib.strings.removePrefix "[" (lib.strings.removeSuffix "]" str);
in
{
  options.vim.lsp = {
    enable = mkEnableOption "neovim lsp support";
    folds = mkEnableOption "Folds via nvim-ufo";
    formatOnSave = mkEnableOption "Format on save";

    nix = {
      enable = mkEnableOption "Nix LSP";
      type = mkOption {
        type = types.enum [ "nixd" "nil" "rnix-lsp" ];
        default = "nil";
        description = "Whether to use `nixd`, `nil` or `rnix-lsp`";
      };
    };

    dhall = mkEnableOption "Dhall LSP";
    elm = mkEnableOption "Elm LSP";
    haskell = mkEnableOption "Haskell LSP (hls)";
    unison = mkEnableOption "Unison LSP";

    scala = {
      enable = mkEnableOption "Scala LSP (Metals)";
      metals = {
        package = mkOption {
          type = types.package;
          default = pkgs.metals;
          description = "The Metals package to use. Default pkgs.metals.";
        };

        serverProperties = mkOption {
          type = types.listOf types.str;
          default = [
            "-Xmx2G"
            "-XX:+UseZGC"
            "-XX:ZUncommitDelay=30"
            "-XX:ZCollectionInterval=5"
            "-XX:+IgnoreUnrecognizedVMOptions"
          ];
          description = "The Metals server properties.";
          example = [
            "-Dmetals.enable-best-effort=true"
            "-XX:+UseStringDeduplication"
            "-XX:+IgnoreUnrecognizedVMOptions"
          ];
        };
      };
    };

    smithy = {
      enable = mkEnableOption "Smithy Language LSP";
      launcher = mkOption {
        type = types.package;
        default = pkgs.coursier;
        description = "The launcher of the LSP server";
      };
      server = {
        name = mkOption {
          type = types.str;
          default = "com.disneystreaming.smithy:smithy-language-server";
          description = "The Smithy LSP server dependency (usually a jar)";
        };
        version = mkOption {
          type = types.str;
          default = "0.0.30";
          description = "The Smithy LSP server dependency version";
        };
        class = mkOption {
          type = types.str;
          default = "software.amazon.smithy.lsp.Main";
          description = "The Smithy LSP server main class";
        };
      };
    };

    sql = mkEnableOption "SQL Language LSP";
    ts = mkEnableOption "TS language LSP";

    rust = {
      enable = mkEnableOption "Rust LSP";
      rustAnalyzerOpts = mkOption {
        type = types.str;
        default = ''
          ["rust-analyzer"] = {
            experimental = {
              procAttrMacros = true,
            },
          },
        '';
        description = "options to pass to rust analyzer";
      };
    };
    python = mkEnableOption "Python LSP";
    clang = mkEnableOption "C language LSP";
    go = mkEnableOption "Go language LSP";
  };

  config = mkIf cfg.enable {
    vim.startPlugins = with pkgs.neovimPlugins;
      [ nvim-lspconfig ] ++
      (withPlugins config.vim.autocomplete.enable [ cmp-nvim-lsp ]) ++
      (withPlugins cfg.sql [ sqls-nvim ]) ++
      (withPlugins cfg.scala.enable [ nvim-metals ]) ++
      (withPlugins cfg.unison [ pkgs.vimPlugins.unison ]) ++
      (withPlugins cfg.folds [ promise-async nvim-ufo ]) ++
      (withPlugins cfg.rust.enable [ crates-nvim rust-tools ]);

    vim.configRC = ''
      ${writeIf cfg.rust.enable ''
          function! MapRustTools()
            nnoremap <silent><leader>ri <cmd>lua require('rust-tools.inlay_hints').toggle_inlay_hints()<CR>
            nnoremap <silent><leader>rr <cmd>lua require('rust-tools.runnables').runnables()<CR>
            nnoremap <silent><leader>re <cmd>lua require('rust-tools.expand_macro').expand_macro()<CR>
            nnoremap <silent><leader>rc <cmd>lua require('rust-tools.open_cargo_toml').open_cargo_toml()<CR>
            nnoremap <silent><leader>rg <cmd>lua require('rust-tools.crate_graph').view_crate_graph('x11', nil)<CR>
          endfunction

          autocmd filetype rust nnoremap <silent><leader>ri <cmd>lua require('rust-tools.inlay_hints').toggle_inlay_hints()<CR>
          autocmd filetype rust nnoremap <silent><leader>rr <cmd>lua require('rust-tools.runnables').runnables()<CR>
          autocmd filetype rust nnoremap <silent><leader>re <cmd>lua require('rust-tools.expand_macro').expand_macro()<CR>
          autocmd filetype rust nnoremap <silent><leader>rc <cmd>lua require('rust-tools.open_cargo_toml').open_cargo_toml()<CR>
          autocmd filetype rust nnoremap <silent><leader>rg <cmd>lua require('rust-tools.crate_graph').view_crate_graph('x11', nil)<CR>
        ''
      }

      ${writeIf cfg.nix.enable ''
          autocmd filetype nix setlocal tabstop=2 shiftwidth=2 softtabstop=2
        ''
      }

      ${writeIf cfg.clang ''
          " c syntax for header (otherwise breaks treesitter highlighting)
          " https://www.reddit.com/r/neovim/comments/orfpcd/question_does_the_c_parser_from_nvimtreesitter/
          let g:c_syntax_for_h = 1
        ''
      }
    '';

    vim.luaConfigRC = ''
      local attach_keymaps = function(client, bufnr)
        local opts = { noremap=true, silent=true }

        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lgD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lgd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lgi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lgr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lgt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lgn', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lgp', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
      
        -- Alternative keybinding for code actions for when code-action-menu does not work as expected.
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)

        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lwa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lwr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lwl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)

        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lh', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lsh', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ln', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'F', '<cmd>lua vim.lsp.buf.format { async = true }<CR>', opts)

        ${writeIf cfg.scala.enable ''
        -- Metals specific
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lmc', '<cmd>lua require("metals").commands()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lmi', '<cmd>lua require("metals").toggle_setting("showImplicitArguments")<CR>', opts)
        ''}
      end

      vim.g.formatsave = ${
        if cfg.formatOnSave
        then "true"
        else "false"
      };

      -- Enable formatting
      format_callback = function(client, bufnr)
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = augroup,
          buffer = bufnr,
          callback = function()
            if vim.g.formatsave then
                local params = require'vim.lsp.util'.make_formatting_params({})
                client.request('textDocument/formatting', params, nil, bufnr)
            end
          end
        })
      end

      default_on_attach = function(client, bufnr)
        attach_keymaps(client, bufnr)
        format_callback(client, bufnr)
      end

      -- Enable lspconfig
      local capabilities = vim.lsp.protocol.make_client_capabilities()

      ${writeIf cfg.folds ''
        capabilities.textDocument.foldingRange = {
          dynamicRegistration = false,
          lineFoldingOnly = true
        }

        -- Display number of folded lines
        local ufo_handler = function(virtText, lnum, endLnum, width, truncate)
          local newVirtText = {}
          local suffix = ('  %d '):format(endLnum - lnum)
          local sufWidth = vim.fn.strdisplaywidth(suffix)
          local targetWidth = width - sufWidth
          local curWidth = 0
          for _, chunk in ipairs(virtText) do
            local chunkText = chunk[1]
            local chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if targetWidth > curWidth + chunkWidth then
              table.insert(newVirtText, chunk)
            else
                chunkText = truncate(chunkText, targetWidth - curWidth)
                local hlGroup = chunk[2]
                table.insert(newVirtText, {chunkText, hlGroup})
                chunkWidth = vim.fn.strdisplaywidth(chunkText)
                -- str width returned from truncate() may less than 2nd argument, need padding
                if curWidth + chunkWidth < targetWidth then
                  suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
                end
                break
            end
            curWidth = curWidth + chunkWidth
          end
          table.insert(newVirtText, {suffix, 'MoreMsg'})
          return newVirtText
        end

        require('ufo').setup({
           fold_virt_text_handler = ufo_handler
        })

        -- Using ufo provider needs a large value
        vim.o.foldlevel = 99 
        vim.o.foldlevelstart = 99
        vim.o.foldenable = true

        -- Using ufo provider need remap `zR` and `zM`
        vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
        vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
        vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds)
        vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith)
      ''}

      ${let
        cfg = config.vim.autocomplete;
      in
        writeIf cfg.enable ''
          capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
        ''
      };

      ${writeIf keys.enable ''
        wk.register({
          ["<leader>l"] = {
            name = "LSP",
          },
        })

        ${writeIf cfg.scala.enable ''
        wk.register({
          ["<leader>m"] = {
            name = "Metals",
            w = { "<cmd>lua require'metals'.worksheet_hover()<CR>", "Worksheet hover" },
            d = { "<cmd>lua require'metals'.open_all_diagnostics()<CR>", "Open all diagnostics" },
          },
        })
        ''}
      ''}

      ${writeIf cfg.rust.enable ''
        -- Rust config

        local rustopts = {
          tools = {
            autoSetHints = true,
            hover_with_actions = false,
            inlay_hints = {
              only_current_line = false,
            }
          },
          server = {
            capabilities = capabilities,
            on_attach = default_on_attach,
            cmd = {"${pkgs.rust-analyzer}/bin/rust-analyzer"},
            settings = {
              ${cfg.rust.rustAnalyzerOpts}
            }
          }
        }

        require('crates').setup {}
        require('rust-tools').setup(rustopts)
      ''}

      ${writeIf cfg.python ''
        -- Python config
        vim.lsp.config['pyright'] = {
          capabilities = capabilities;
          on_attach=default_on_attach;
          cmd = {"${pkgs.nodePackages.pyright}/bin/pyright-langserver", "--stdio"}
        }
        vim.lsp.enable('pyright')
      ''}

      ${writeIf (cfg.nix.enable && cfg.nix.type == "nixd") ''
        -- Nix config
        vim.lsp.config['nixd'] = {
          capabilities = capabilities;
          on_attach = function(client, bufnr)
            attach_keymaps(client, bufnr)
          end,
          settings = {
            ['nixd'] = {
              formatting = {
                command = {"${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt"}
              },
              diagnostic = {
                -- See values: https://github.com/nix-community/nixd/blob/590eccaa079929daa58316f5386dbcc150e2d50d/libnixf/src/Basic/diagnostic.py#L17
                suppress = {"deprecated-url-literal"}
              }
            }
          };
          cmd = {"${pkgs.nixd}/bin/nixd"}
        }
        vim.lsp.enable('nixd')
      ''}

      ${writeIf (cfg.nix.enable && cfg.nix.type == "nil") ''
        -- Nix config
        vim.lsp.config['nil_ls'] = {
          capabilities = capabilities;
          on_attach = function(client, bufnr)
            attach_keymaps(client, bufnr)
          end,
          settings = {
            ['nil'] = {
              formatting = {
                command = {"${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt"}
              },
              diagnostics = {
                ignored = { "uri_literal" },
                excludedFiles = { }
              },
              nix = {
                flake = {
                  autoArchive = false,
                  autoEvalInputs = false,
                  nixpkgsInputName = "nixpkgs"
                }
              }
            }
          };
          cmd = {"${pkgs.nil}/bin/nil"}
        }
        vim.lsp.enable('nil_ls')
      ''}

      ${writeIf (cfg.nix.enable && cfg.nix.type == "rnix-lsp") ''
        -- Nix config
        vim.lsp.config['rnix'] = {
          capabilities = capabilities;
          on_attach = function(client, bufnr)
            attach_keymaps(client, bufnr)
          end,
          cmd = {"${pkgs.rnix-lsp}/bin/rnix-lsp"}
        }
        vim.lsp.enable('rnix')
      ''}

      ${writeIf cfg.clang ''
        -- CCLS (clang) config
        vim.lsp.config['ccls'] = {
          capabilities = capabilities;
          on_attach=default_on_attach;
          cmd = {"${pkgs.ccls}/bin/ccls"}
        }
        vim.lsp.enable('ccls')
      ''}

      ${writeIf cfg.sql ''
        -- SQLS config
        vim.lsp.config['sqls'] = {
          on_attach = function(client)
            client.server_capabilities.execute_command = true
            on_attach_keymaps(client, bufnr)
            require'sqls'.setup{}
          end,
          cmd = {"${pkgs.sqls}/bin/sqls", "-config", string.format("%s/config.yml", vim.fn.getcwd()) }
        }
        vim.lsp.enable('sqls')
      ''}

      ${writeIf cfg.go ''
        -- Go config
        vim.lsp.config['gopls'] = {
          capabilities = capabilities;
          on_attach = default_on_attach;
          cmd = {"${pkgs.gopls}/bin/gopls", "serve"},
        }
        vim.lsp.enable('gopls')
      ''}

      ${writeIf cfg.dhall ''
        -- Dhall config
        vim.lsp.config['dhall_lsp_server'] = {
          capabilities = capabilities;
          on_attach = default_on_attach;
          cmd = { "${pkgs.dhall-lsp-server}/bin/dhall-lsp-server" };
        }
        vim.lsp.enable('dhall_lsp_server')
      ''}

      ${writeIf cfg.elm ''
        -- Elm config
        vim.lsp.config['elmls'] = {
          capabilities = capabilities;
          on_attach = default_on_attach;
          init_options = {
             elmPath = "${pkgs.elmPackages.elm}/bin/elm",
             elmFormatPath = "${pkgs.elmPackages.elm-format}/bin/elm-format",
             elmTestPath = "${pkgs.elmPackages.elm-test}/bin/elm-test",
             elmAnalyseTrigger = "change"
          };
          cmd = { "${pkgs.elmPackages.elm-language-server}/bin/elm-language-server" };
          root_markers = { "elm.json" };
        }
        vim.lsp.enable('elmls')
      ''}

      ${writeIf cfg.haskell ''
        -- Haskell config
        vim.lsp.config['hls'] = {
          capabilities = capabilities;
          on_attach = default_on_attach;
          cmd = { "${pkgs.haskell-language-server}/bin/haskell-language-server-wrapper", "--lsp" };
          root_markers = { "hie.yaml", "stack.yaml", ".cabal", "cabal.project", "package.yaml" };
        }
        vim.lsp.enable('hls')
      ''}

      ${writeIf cfg.unison ''
        -- Unison config
        vim.lsp.config['unison'] = {
          capabilities = capabilities;
          on_attach = default_on_attach;
          cmd = { "nc", "localhost", "5757" };
          filetypes = { "unison" };
          root_markers = { "*.u" };
        }
        vim.lsp.enable('unison')
      ''}

      ${writeIf cfg.scala.enable ''
        -- Scala nvim-metals config
        metals_config = require('metals').bare_config()
        metals_config.capabilities = capabilities
        metals_config.on_attach = default_on_attach

        metals_config.settings = {
           metalsBinaryPath = "${cfg.scala.metals.package}/bin/metals",
           autoImportBuild = "off",
           defaultBspToBuildTool = true,
           showImplicitArguments = true,
           showImplicitConversionsAndClasses = true,
           showInferredType = true,
           superMethodLensesEnabled = true,
           excludedPackages = {
             "akka.actor.typed.javadsl",
             "com.github.swagger.akka.javadsl"
           },
           serverProperties = {
             ${metalsServerProperties}
           }
        }

        metals_config.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
          vim.lsp.diagnostic.on_publish_diagnostics, {
            virtual_text = {
              prefix = '',
            }
          }
        )

        -- without doing this, autocommands that deal with filetypes prohibit messages from being shown
        vim.opt_global.shortmess:remove("F")

        vim.cmd([[augroup lsp]])
        vim.cmd([[autocmd!]])
        vim.cmd([[autocmd FileType java,scala,sbt lua require('metals').initialize_or_attach(metals_config)]])
        vim.cmd([[augroup end]])
      ''}

      ${writeIf cfg.nix.enable ''
        -- Nix formatter
      ''}

      ${writeIf cfg.smithy.enable ''
        -- Smithy config
        vim.cmd([[au BufRead,BufNewFile *.smithy setfiletype smithy]])

        vim.lsp.config['smithy_ls'] = {
          capabilities = capabilities;
          on_attach = function(client, bufnr)
            attach_keymaps(client, bufnr)
          end,
          cmd = {
            '${cfg.smithy.launcher}/bin/cs', 'launch',
            '${cfg.smithy.server.name}:${cfg.smithy.server.version}',
            '--ttl', '1h',
            '--main-class', '${cfg.smithy.server.class}',
            '--', '0'
          },
          root_markers = { "smithy-build.json" }
        }
        vim.lsp.enable('smithy_ls')
      ''}

      ${writeIf cfg.ts ''
        -- TS config
        vim.lsp.config['ts_ls'] = {
          capabilities = capabilities;
          on_attach = function(client, bufnr)
            attach_keymaps(client, bufnr)
          end,
          cmd = { "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server", "--stdio" }
        }
        vim.lsp.enable('ts_ls')
      ''}
    '';
  };
}

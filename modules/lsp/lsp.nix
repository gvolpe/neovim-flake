{ pkgs, config, lib, ... }:

with lib;
with builtins;

let
  cfg = config.vim.lsp;

  # Smithy packages
  cs = "${pkgs.coursier}/bin/cs";
  sls = {
    name = "com.disneystreaming.smithy:smithy-language-server";
    version = "0.0.20";
  };
in
{
  options.vim.lsp = {
    enable = mkEnableOption "neovim lsp support";
    folds = mkEnableOption "Folds via nvim-ufo";
    formatOnSave = mkEnableOption "Format on save";

    nix = {
      enable = mkEnableOption "Nix LSP";
      type = mkOption {
        type = types.enum [ "nil" "rnix-lsp" ];
        default = "rnix-lsp";
        description = "Whether to use `nil` or `rnix-lsp`";
      };
    };

    dhall = mkEnableOption "Dhall LSP";
    elm = mkEnableOption "Elm LSP";
    haskell = mkEnableOption "Haskell LSP (hls)";

    scala = {
      enable = mkEnableOption "Scala LSP (Metals)";
      metals = mkOption {
        type = types.package;
        default = pkgs.metals;
        description = "The Metals package to use. Default pkgs.metals.";
      };
    };

    smithy = mkEnableOption "Smithy Language LSP";
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
      [ nvim-lspconfig null-ls ] ++
      (withPlugins (config.vim.autocomplete.enable && (config.vim.autocomplete.type == "nvim-cmp")) [ cmp-nvim-lsp ]) ++
      (withPlugins cfg.sql [ sqls-nvim ]) ++
      (withPlugins cfg.scala.enable [ nvim-metals ]) ++
      (withPlugins cfg.folds [ promise-async nvim-ufo ]) ++
      (withPlugins cfg.rust.enable [ crates-nvim rust-tools ]);

    vim.nnoremap = withAttrSet cfg.scala.enable {
      "<silent> <leader>ws" = "<cmd>lua require'metals'.worksheet_hover()<CR>";
      "<silent> <leader>ad" = "<cmd>lua require'metals'.open_all_diagnostics()<CR>";
    };

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

      local null_ls = require("null-ls")
      local null_helpers = require("null-ls.helpers")
      local null_methods = require("null-ls.methods")

      local ls_sources = {
        ${writeIf cfg.python
      ''
          null_ls.builtins.formatting.black.with({
            command = "${pkgs.black}/bin/black",
          }),
        ''}
        -- Commented out for now
        --${writeIf (config.vim.git.enable && config.vim.git.gitsigns.enable) ''
        --  null_ls.builtins.code_actions.gitsigns,
        --''}
        ${writeIf cfg.sql
      ''
          null_helpers.make_builtin({
            method = null_methods.internal.FORMATTING,
            filetypes = { "sql" },
            generator_opts = {
              to_stdin = true,
              ignore_stderr = true,
              suppress_errors = true,
              command = "${pkgs.sqlfluff}/bin/sqlfluff",
              args = {
                "fix",
                "-",
              },
            },
            factory = null_helpers.formatter_factory,
          }),

          null_ls.builtins.diagnostics.sqlfluff.with({
            command = "${pkgs.sqlfluff}/bin/sqlfluff",
            extra_args = {"--dialect", "postgres"}
          }),
        ''}

        ${writeIf cfg.ts
      ''
          null_ls.builtins.diagnostics.eslint,
          null_ls.builtins.formatting.prettier,
        ''}
      }

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

      -- Enable null-ls
      require('null-ls').setup({
        diagnostics_format = "[#{m}] #{s} (#{c})",
        debounce = 250,
        default_timeout = 5000,
        sources = ls_sources,
        on_attach=default_on_attach
      })

      -- Enable lspconfig
      local lspconfig = require('lspconfig')

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
        writeIf cfg.enable
        (
          if cfg.type == "nvim-compe"
          then ''
            vim.capabilities.textDocument.completion.completionItem.snippetSupport = true
            capabilities.textDocument.completion.completionItem.resolveSupport = {
              properties = {
                'documentation',
                'detail',
                'additionalTextEdits',
              }
            }
          ''
          else ''
            capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
          ''
        )}

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

        require('crates').setup {
          null_ls = {
            enabled = true,
            name = "crates.nvim",
          }
        }
        require('rust-tools').setup(rustopts)
      ''}

      ${writeIf cfg.python ''
        -- Python config
        lspconfig.pyright.setup{
          capabilities = capabilities;
          on_attach=default_on_attach;
          cmd = {"${pkgs.nodePackages.pyright}/bin/pyright-langserver", "--stdio"}
        }
      ''}

      ${writeIf (cfg.nix.enable && cfg.nix.type == "nil") ''
        -- Nix config
        lspconfig.nil_ls.setup{
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
              }
            }
          };
          cmd = {"${pkgs.nil}/bin/nil"}
        }
      ''}

      ${writeIf (cfg.nix.enable && cfg.nix.type == "rnix-lsp") ''
        -- Nix config
        lspconfig.rnix.setup{
          capabilities = capabilities;
          on_attach = function(client, bufnr)
            attach_keymaps(client, bufnr)
          end,
          cmd = {"${pkgs.rnix-lsp}/bin/rnix-lsp"}
        }
      ''}

      ${writeIf cfg.clang ''
        -- CCLS (clang) config
        lspconfig.ccls.setup{
          capabilities = capabilities;
          on_attach=default_on_attach;
          cmd = {"${pkgs.ccls}/bin/ccls"}
        }
      ''}

      ${writeIf cfg.sql ''
        -- SQLS config
        lspconfig.sqls.setup {
          on_attach = function(client)
            client.server_capabilities.execute_command = true
            on_attach_keymaps(client, bufnr)
            require'sqls'.setup{}
          end,
          cmd = {"${pkgs.sqls}/bin/sqls", "-config", string.format("%s/config.yml", vim.fn.getcwd()) }
        }
      ''}

      ${writeIf cfg.go ''
        -- Go config
        lspconfig.gopls.setup {
          capabilities = capabilities;
          on_attach = default_on_attach;
          cmd = {"${pkgs.gopls}/bin/gopls", "serve"},
        }
      ''}

      ${writeIf cfg.dhall ''
        -- Dhall config
        lspconfig.dhall_lsp_server.setup {
          capabilities = capabilities;
          on_attach = default_on_attach;
          cmd = { "${pkgs.dhall-lsp-server}/bin/dhall-lsp-server" };
        }
      ''}

      ${writeIf cfg.elm ''
        -- Elm config
        lspconfig.elmls.setup {
          capabilities = capabilities;
          on_attach = default_on_attach;
          init_options = {
             elmPath = "${pkgs.elmPackages.elm}/bin/elm",
             elmFormatPath = "${pkgs.elmPackages.elm-format}/bin/elm-format",
             elmTestPath = "${pkgs.elmPackages.elm-test}/bin/elm-test",
             elmAnalyseTrigger = "change"
          };
          cmd = { "${pkgs.elmPackages.elm-language-server}/bin/elm-language-server" };
          root_dir = lspconfig.util.root_pattern("elm.json");
        }
      ''}

      ${writeIf cfg.haskell ''
        -- Haskell config
        lspconfig.hls.setup {
          capabilities = capabilities;
          on_attach = default_on_attach;
          cmd = { "${pkgs.haskell-language-server}/bin/haskell-language-server-wrapper", "--lsp" };
          root_dir = lspconfig.util.root_pattern("hie.yaml", "stack.yaml", ".cabal", "cabal.project", "package.yaml");
        }
      ''}

      ${writeIf cfg.scala.enable ''
        -- Scala nvim-metals config
        metals_config = require('metals').bare_config()
        metals_config.capabilities = capabilities
        metals_config.on_attach = default_on_attach

        metals_config.settings = {
           metalsBinaryPath = "${cfg.scala.metals}/bin/metals",
           showImplicitArguments = true,
           showImplicitConversionsAndClasses = true,
           showInferredType = true,
           excludedPackages = {
             "akka.actor.typed.javadsl",
             "com.github.swagger.akka.javadsl"
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

      ${writeIf cfg.nix.enable
    ''
        -- Nix formatter
        null_ls.builtins.formatting.alejandra.with({
          command = "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt";
        });
      ''}

      ${writeIf cfg.smithy ''
        -- Smithy config
        vim.cmd([[au BufRead,BufNewFile *.smithy setfiletype smithy]])

        lspconfig.smithy.setup {
          capabilities = capabilities;
          on_attach = function(client, bufnr)
            attach_keymaps(client, bufnr)
          end,
          cmd = { '${cs}', 'launch', '${sls.name}:${sls.version}', '--' , '0' },
          root_dir = lspconfig.util.root_pattern("smithy-build.json")
        }
      ''}

      ${writeIf cfg.ts ''
        -- TS config
        lspconfig.tsserver.setup {
          capabilities = capabilities;
          on_attach = function(client, bufnr)
            attach_keymaps(client, bufnr)
          end,
          cmd = { "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server", "--stdio" }
        }
      ''}
    '';
  };
}

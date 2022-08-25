{ pkgs, config, lib, ... }:

with lib;
with builtins;

let
  cfg = config.vim.lsp;
in
{
  options.vim.lsp = {
    enable = mkEnableOption "neovim lsp support";
    formatOnSave = mkEnableOption "Format on save";

    nix = mkEnableOption "Nix LSP";
    dhall = mkEnableOption "Dhall LSP";
    elm = mkEnableOption "Elm LSP";
    haskell = mkEnableOption "Haskell LSP (hls)";
    scala = mkEnableOption "Scala LSP (Metals)";

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

  config = mkIf cfg.enable (
    {
      vim.startPlugins = with pkgs.neovimPlugins;
        [ nvim-lspconfig null-ls ] ++
        (withPlugins (config.vim.autocomplete.enable && (config.vim.autocomplete.type == "nvim-cmp")) [ cmp-nvim-lsp ]) ++
        (withPlugins cfg.sql [ sqls-nvim ]) ++
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

        ${writeIf cfg.nix ''
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
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lgt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lgn', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lgp', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)

          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lwa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lwr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lwl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)

          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lh', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ls', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ln', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', 'F', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
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
              capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
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

        ${writeIf cfg.nix ''
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

        ${writeIf cfg.scala ''
          -- Scala Metals config
          lspconfig.metals.setup {
            cmd = { "${pkgs.metals}/bin/metals" };
            capabilities = capabilities;
            on_attach = default_on_attach;
            init_options = {
              compilerOptions = {
                snippetAutoIndent = false
              },
              isHttpEnabled = true,
              statusBarProvider = "show-message"
            };
            message_level = 4;
            root_dir = lspconfig.util.root_pattern("build.sbt", "build.sc", "build.gradle", "pom.xml");
          }
        ''}

        ${writeIf cfg.nix
        ''
          -- Nix formatter
          null_ls.builtins.formatting.alejandra.with({
            command = "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt";
          });
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
    }
  );
}

{ ... }:

let
  pattern = "smithy-build.json";
in
{
  lua = ''
    local util = require 'lspconfig.util'

    return {
      default_config = {
        cmd = { 'override-me' },
        filetypes = { 'smithy' },
        root_dir = util.root_pattern('${pattern}'),
        message_level = vim.lsp.protocol.MessageType.Log,
        init_options = {
          statusBarProvider = 'show-message',
          isHttpEnabled = true,
          compilerOptions = {
            snippetAutoIndent = false,
          },
        },
      },
      docs = {
        description = [[
          LSP configuration for Smithy
        ]],
        default_config = {
          root_dir = [[util.root_pattern("${pattern}")]],
        },
      },
    }
  '';
}

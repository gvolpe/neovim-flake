{ pkgs, config, lib, ... }:

with lib;
with builtins;

let
  cfg = config.vim.lsp;
  keys = config.vim.keys.whichKey;
in
{
  options.vim.lsp.trouble.enable = mkEnableOption "trouble diagnostics viewer";

  config = mkIf (cfg.enable && cfg.trouble.enable) {
    vim.startPlugins = with pkgs.neovimPlugins; [ trouble ];

    vim.nnoremap = {
      "<leader>ltd" = "<cmd>Trouble diagnostics toggle focus=true filter.buf=0 win.type=split win.position=bottom<CR>";
      "<leader>lts" = "<cmd>Trouble symbols toggle focus=true filter.buf=0 win.type=split win.position=bottom<CR>";
    };

    vim.luaConfigRC = ''
      -- Enable trouble diagnostics viewer
      require("trouble").setup {}

      ${writeIf keys.enable ''
        wk.register({
          ["<leader>lt"] = {
            name = "Trouble",
          },
        })
      ''}
    '';
  };
}

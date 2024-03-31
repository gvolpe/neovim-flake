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
      "<leader>lwd" = "<cmd> TroubleToggle workspace_diagnostics<CR>";
      "<leader>ld" = "<cmd> TroubleToggle document_diagnostics<CR>";
      "<leader>lr" = "<cmd> TroubleToggle lsp_references<CR>";
      "<leader>xx" = "<cmd> TroubleToggle<CR>";
      "<leader>xq" = "<cmd> TroubleToggle quickfix<CR>";
      "<leader>xl" = "<cmd> TroubleToggle loclist<CR>";
    };

    vim.luaConfigRC = ''
      -- Enable trouble diagnostics viewer
      require("trouble").setup {}

      ${writeIf keys.enable ''
        wk.register({
          ["<leader>x"] = {
            name = "Troubles",
          },
        })
      ''}
    '';
  };
}

{ pkgs, config, lib, ... }:

with lib;
with builtins;

let
  cfg = config.vim.lsp;
  keys = config.vim.keys.whichKey;
in
{
  options.vim.lsp.nvimCodeActionMenu.enable = mkEnableOption "nvim code action menu";

  config = mkIf (cfg.enable && cfg.nvimCodeActionMenu.enable) {
    vim.startPlugins = with pkgs.neovimPlugins; [
      nvim-code-action-menu
    ];

    vim.nnoremap = {
      "<silent><leader>ac" = "<cmd> CodeActionMenu<CR>";
    };

    vim.luaConfigRC = ''
      ${writeIf keys.enable ''
        wk.add({
          { "<leader>a", group = "Code actions" },
        })
      ''}
    '';
  };
}

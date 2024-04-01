{ config, lib, ... }:

with lib;

let
  cfg = config.vim.shortcuts;
in
{
  options.vim.shortcuts = {
    enable = mkEnableOption "enable shortcuts";
  };

  config = mkIf cfg.enable {
    vim.nnoremap =
      {
        # Alias for <leader>ff
        "<C-p>" = "<cmd> Telescope find_files<CR>";

        # Disable the annoying and useless ex-mode
        "gQ" = "<nop>";

        ### Handle window actions with Meta instead of <C-w>
        # Switching
        "<M-h>" = "<C-w>h";
        "<M-j>" = "<C-w>j";
        "<M-k>" = "<C-w>k";
        "<M-l>" = "<C-w>l";

        # Moving
        "<M-H>" = "<C-w>H";
        "<M-J>" = "<C-w>J";
        "<M-K>" = "<C-w>K";
        "<M-L>" = "<C-w>L";
        "<M-x>" = "<C-w>x";

        # Resizing
        "<M-=>" = "<C-w>=";
        "<M-+>" = "<C-w>+";
        "<M-->" = "<C-w>-";
        "<M-<>" = "<C-w><";
        "<M->>" = "<C-w>>";
      }
      // (withAttrSet config.vim.telescope.tabs.enable {
        "<C-p>" = "<cmd>lua require('search').open()<CR>";
      })
      // (withAttrSet config.vim.lsp.enable {
        "K" = "<cmd>lua vim.lsp.buf.hover()<CR>";
      })
      // (withAttrSet config.vim.treesitter.enable { });
  };
}


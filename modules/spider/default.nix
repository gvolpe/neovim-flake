{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.vim.spider;
in
{
  options.vim.spider = {
    enable = mkOption {
      type = types.bool;
      description = "Enable the nvim-spider plugin";
    };
    skipInsignificantPunctuation= mkOption {
      type = types.bool;
      default = true;
      description = "Plugin setting";
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins = with pkgs.neovimPlugins; [ nvim-spider ];

    vim.luaConfigRC = ''
      require("spider").setup({
        skipInsignificantPunctuation = ${boolToString cfg.skipInsignificantPunctuation}
      })

      vim.keymap.set({"n", "o", "x"}, "w", "<cmd>lua require('spider').motion('w')<CR>", { desc = "Spider-w" })
      vim.keymap.set({"n", "o", "x"}, "e", "<cmd>lua require('spider').motion('e')<CR>", { desc = "Spider-e" })
      vim.keymap.set({"n", "o", "x"}, "b", "<cmd>lua require('spider').motion('b')<CR>", { desc = "Spider-b" })
      vim.keymap.set({"n", "o", "x"}, "ge", "<cmd>lua require('spider').motion('ge')<CR>", { desc = "Spider-ge" })
    '';
  };
}

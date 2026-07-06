{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.vim.jujutsu;
  keys = config.vim.keys.whichKey;
in
{
  options.vim.jujutsu = {
    enable = mkOption {
      type = types.bool;
      description = "Enable the jujutsu-nvim plugin";
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins = with pkgs; [
      vimPlugins.jujutsu-nvim
      neovimPlugins.diffview
    ];

    vim.luaConfigRC = ''
      require('jujutsu-nvim').setup({
        diff_preset = "diffview",
      })

      ${writeIf keys.enable ''
        wk.register({
          ["<leader>j"] = {
            name = "Jujutsu",
            d = { "<cmd>:JJ diff<CR>", "diff" },
            j = { "<cmd>:JJ<CR>", "log" },
            s = { "<cmd>:JJ status<CR>", "status" },
          },
        })
      ''}
    '';
  };
}


{ config, lib, pkgs, ... }:

with lib;
with builtins;

let
  cfg = config.vim.mind;
in
{
  options.vim.mind = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Mind plugin";
    };
  };

  config = mkIf cfg.enable ({
    vim.startPlugins = [ pkgs.neovimPlugins.mind-nvim ];

    vim.nnoremap = {
      "<leader>mo" = "<cmd> MindOpenMain<CR>";
      "<leader>mc" = "<cmd> MindClose<CR>";
    };

    vim.luaConfigRC = ''
      require('mind').setup({
        persistence = {
          state_path = "~/.local/share/mind.nvim/mind.json",
          data_dir = "~/.local/share/mind.nvim/data"
        },
        tree = {
          automatic_creation = true,
          automatic_data_creation = true
        },
        ui = {
          url_open = "${pkgs.xdg-utils}/bin/xdg-open",
          width = 30
        }
      })
    '';
  });
}

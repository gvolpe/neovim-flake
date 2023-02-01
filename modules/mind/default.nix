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

    persistence = {
      dataDir = mkOption {
        default = "~/.local/share/mind.nvim/data";
        description = "Directory for the Mind data files created by the user";
        type = types.str;
      };

      statePath = mkOption {
        default = "~/.local/share/mind.nvim/mind.json";
        description = "Application state file: mind.json";
        type = types.str;
      };
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins = [ pkgs.neovimPlugins.mind-nvim ];

    vim.nnoremap = {
      "<leader>mo" = "<cmd> MindOpenMain<CR>";
      "<leader>mc" = "<cmd> MindClose<CR>";
    };

    vim.luaConfigRC = ''
      require('mind').setup({
        persistence = {
          state_path = "${cfg.persistence.statePath}",
          data_dir = "${cfg.persistence.dataDir}"
        },
        tree = {
          automatic_creation = true,
          automatic_data_creation = true
        },
        ui = {
          url_open = "${pkgs.xdg-utils}/bin/xdg-open",
          width = 40
        }
      })
    '';
  };
}

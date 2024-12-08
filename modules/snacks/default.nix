{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.vim.snacks;
  neovim = config.vim.neovim.package;
in
{
  options.vim.snacks = {
    enable = mkOption {
      type = types.bool;
      description = "Enable dashboard from the Snacks plugin";
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins = [ pkgs.neovimPlugins.snacks ];

    vim.luaConfigRC = ''
      require('snacks').setup({
        bigfile = { enabled = false },
        dashboard = {
          enabled = true,
          width = 60,
          preset = {
            keys = {
              { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
              { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
              { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
              { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
              { icon = " ", key = "q", desc = "Exit", action = ":qa" },
            },
          },
          sections = {
            {
              section = "terminal",
              cmd = "${pkgs.chafa}/bin/chafa ${../../img/neovim-logo.png}",
            },
            { text = "Version: ${neovim.version}", align = "center", padding = 1 },
            { section = "keys", gap = 1, padding = 1 },
          },
        },
        notifier = {
          enabled = false,
          timeout = 2000,
        },
        quickfile = { enabled = false },
        statuscolumn = { enabled = false },
        words = { enabled = false },
      })
    '';
  };
}

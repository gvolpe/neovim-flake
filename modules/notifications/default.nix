{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.vim.notifications;
in
{
  options.vim.notifications = {
    enable = mkOption {
      type = types.bool;
      description = "Enable the nvim-notify plugin";
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins = with pkgs.neovimPlugins; [ nvim-notify ];

    # e.g. :lua vim.notify("test", "info", { title = "Hey!"})
    vim.luaConfigRC = ''
      require("notify").setup({
        background_colour = "#000000",
      })
      vim.notify = require("notify")
    '';
  };
}

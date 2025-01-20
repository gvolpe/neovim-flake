{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.vim.mini;
in
{
  options.vim.mini = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable mini.nvim (mini.ai and mini.surround) plugins";
    };
  };

  config = mkIf cfg.enable
    {
      vim.startPlugins = [ pkgs.neovimPlugins.mini-nvim ];

      vim.luaConfigRC = ''
        require('mini.ai').setup()
        require('mini.surround').setup()
      '';
    };
}

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.vim.hop;
in
{
  options.vim.hop = {
    enable = mkEnableOption "Enable Hop plugin (easy motion)";
  };

  config = mkIf cfg.enable {
    vim.startPlugins = [ pkgs.neovimPlugins.hop ];

    vim.nnoremap = {
      "<leader>h" = "<cmd> HopPattern<CR>";
    };

    vim.luaConfigRC = ''
      require('hop').setup()
    '';
  };
}

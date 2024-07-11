{ config, lib, pkgs, ... }:

with lib;
with builtins;

let
  cfg = config.vim.hurl;
in
{
  options.vim.hurl = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable HURL (hurl.dev) syntax highlights";
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins = [ pkgs.neovimPlugins.hurl-nvim ];

    vim.luaConfigRC = ''
      require('hurl').setup({})
    '';
  };
}


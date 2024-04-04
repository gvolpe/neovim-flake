{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.vim.zen;
in
{
  options.vim.zen = {
    enable = mkOption {
      type = types.bool;
      description = "Enable Zen mode (distraction-free coding) with twilight (dim code)";
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins = with pkgs.neovimPlugins; [ twilight zen-mode ];

    vim.nnoremap = {
      "<leader>z" = "<cmd> ZenMode<CR>";
    };

    vim.luaConfigRC = ''
      require('zen-mode').setup()
    '';
  };
}

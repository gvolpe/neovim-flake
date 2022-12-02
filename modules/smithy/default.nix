{ pkgs, config, lib, ... }:

with lib;
with builtins;

let
  cfg = config.vim.smithy;
in
{
  options.vim.smithy = {
    enable = mkEnableOption "Enable vim-smithy (syntax highlighting for smithy)";
  };

  config = mkIf cfg.enable {
    vim.startPlugins = with pkgs.neovimPlugins; [ vim-smithy ];
  };
}

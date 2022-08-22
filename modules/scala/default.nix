{ pkgs, config, lib, ... }:

with lib;
with builtins;

let
  cfg = config.vim.scala;
in
{
  options.vim.scala = {
    highlightMode = mkOption {
      default = "treesitter";
      description = "Whether to rely on treesitter or regex (powered by vim-scala3)";
      type = types.enum [ "treesitter" "regex" ];
    };
  };

  config = {
    vim.startPlugins =
      withPlugins (cfg.highlightMode == "regex") [ pkgs.neovimPlugins.vim-scala3 ];
  };
}

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.vim.fx.automaton;
in
{
  options.vim.fx = {
    automaton = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable Cellular Automaton";
      };
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins = [ pkgs.neovimPlugins.cellular-automaton ];

    vim.nnoremap = {
      "<leader>fml" = "<cmd> CellularAutomaton make_it_rain<CR>";
    };
  };
}

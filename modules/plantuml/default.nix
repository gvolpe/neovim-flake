{ config, lib, pkgs, ... }:

with lib;
with builtins;

let
  cfg = config.vim.plantuml;
in
{
  options.vim.plantuml = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable PlantUML syntax highlights";
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins = [ pkgs.neovimPlugins.vim-plantuml ];

    vim.configRC =
      writeIf cfg.enable ''
        let g:plantuml_set_makeprg=0
      '';
  };
}

{ pkgs, lib, config, ... }:

with lib;
with builtins;

let
  cfg = config.vim.autopairs;
in
{
  options.vim = {
    autopairs = {
      enable = mkEnableOption "enable autopairs";

      type = mkOption {
        type = types.enum [ "nvim-autopairs" ];
        description = "Set the autopairs type. Options: nvim-autopairs [nvim-autopairs]";
      };

      checkTS = mkOption {
        type = types.bool;
        description = "Whether to check treesitter for a pair";
      };
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins = with pkgs.neovimPlugins; [
      (
        if (cfg.type == "nvim-autopairs")
        then nvim-autopairs
        else null
      )
    ];

    vim.luaConfigRC = ''
      ${writeIf (cfg.type == "nvim-autopairs") ''
        ${writeIf cfg.enable ''
          require("nvim-autopairs").setup{}
          ${writeIf (config.vim.autocomplete.type == "nvim-compe") ''
            require('nvim-autopairs.completion.compe').setup({
              map_cr = true,
              map_complete = true,
              auto_select = false,
            })
          ''}
        ''}
      ''}
    '';
  };
}

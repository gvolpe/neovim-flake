{ pkgs, lib, config, ... }:

with lib;

let
  cfg = config.vim.comments;
  keys = config.vim.keys.whichKey;
in
{
  options.vim.comments = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "enable comments plugin";
    };

    type = mkOption {
      default = "nerdcommenter";
      description = "Set the comments plugin. Options: [nerdcommenter] [kommentary]";
      type = types.enum [ "nerdcommenter" "kommentary" ];
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins = [ pkgs.neovimPlugins.${cfg.type} ];

    vim.luaConfigRC = ''
      ${writeIf (cfg.type == "kommentary") ''
        -- Kommentary config
        require('kommentary.config').setup();
        require('kommentary.config').configure_language("nix", {
            single_line_comment_string = "#",
        })
        ''
      }

      ${writeIf keys.enable ''
        wk.register({
          ["<leader>c"] = {
            name = "Commenter",
          },
        })
      ''}
    '';
  };
}

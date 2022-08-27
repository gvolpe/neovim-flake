{ pkgs, config, lib, ... }:

with lib;
with builtins;

let
  cfg = config.vim.theme;
in
{
  options.vim.theme = {
    enable = mkOption {
      type = types.bool;
      description = "Enable Theme";
    };

    name = mkOption {
      type = types.enum [ "nightfox" "onedark" "tokyonight" ];
      description = ''Name of theme to use: "nightfox" "onedark" "tokyonight"'';
    };

    style = mkOption {
      type = with types; (
        if (cfg.name == "tokyonight")
        then (enum [ "day" "night" "storm" ])
        else
          (
            if (cfg.name == "onedark")
            then (enum [ "dark" "darker" "cool" "deep" "warm" "warmer" ])
            else (enum [ "nightfox" "carbonfox" "duskfox" "terafox" "nordfox" ])
          )

      );
      description = ''Theme style: "storm", darker variant "night", and "day"'';
    };

    transparency = mkOption {
      type = types.bool;
      description = "Background transparency";
    };
  };

  config = mkIf cfg.enable (
    let
      transparency = builtins.toString cfg.transparency;
    in
    {
      vim.configRC = mkIf (cfg.name == "tokyonight") ''
        " need to set style before colorscheme to apply
        let g:${cfg.name}_style = "${cfg.style}"
        let g:${cfg.name}_transparent = "${transparency}"
        let g:${cfg.name}_transparent_sidebar = "${transparency}"
        colorscheme ${cfg.name}
      '';

      vim.startPlugins = with pkgs.neovimPlugins; (
        (withPlugins (cfg.name == "nightfox") [ nightfox ]) ++
        (withPlugins (cfg.name == "onedark") [ onedark ]) ++
        (withPlugins (cfg.name == "tokyonight") [ tokyonight ])
      );

      vim.luaConfigRC = ''
        ${writeIf (cfg.name == "nightfox") ''
          -- nightfox theme
          require('nightfox').setup {
            options = {
              style = "${cfg.style}",
              transparent = "${transparency}",
            }
          }
          
          vim.cmd("colorscheme ${cfg.style}")
        ''
        }

        ${writeIf (cfg.name == "onedark") ''
          -- OneDark theme
          require('onedark').setup {
            style = "${cfg.style}",
            transparent = "${transparency}",
          }
          require('onedark').load()
        ''
        }
      '';
    }
  );
}

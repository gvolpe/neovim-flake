{ pkgs, config, lib, ... }:

with lib;
with builtins;

let
  cfg = config.vim.theme;

  enum' = name: flavors: other:
    if (cfg.name == name) then types.enum flavors else other;
in
{
  options.vim.theme = {
    enable = mkOption {
      type = types.bool;
      description = "Enable Theme";
    };

    name = mkOption {
      type = types.enum [ "catppuccin" "nightfox" "onedark" "rose-pine" "tokyonight" ];
      default = "onedark";
      description = ''Name of theme to use: "catppuccin" "nightfox" "onedark" "rose-pine" "tokyonight"'';
    };

    style = mkOption {
      type =
        let
          tn = enum' "tokyonight" [ "day" "night" "storm" ];
          od = enum' "onedark" [ "dark" "darker" "cool" "deep" "warm" "warmer" ];
          nf = enum' "nightfox" [ "nightfox" "carbonfox" "duskfox" "terafox" "nordfox" ];
          rp = enum' "rose-pine" [ "main" "moon" "dawn" ];
          cp = types.enum [ "frappe" "latte" "macchiato" "mocha" ];
        in
        tn (od (nf (rp cp)));
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
        (withPlugins (cfg.name == "tokyonight") [ tokyonight ]) ++
        (withPlugins (cfg.name == "rose-pine") [ rosepine ]) ++
        (withPlugins (cfg.name == "catppuccin") [ catppuccin ])
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

        ${writeIf (cfg.name == "catppuccin") ''
          vim.g.catppuccin_flavour = "${cfg.style}"
          require("catppuccin").setup({
            transparent_background = ${if cfg.transparency then "true" else "false"},
          })
          vim.cmd [[colorscheme catppuccin]]
        ''
        }

        ${writeIf (cfg.name == "rose-pine") ''
          -- Rose Pine theme
          require('rose-pine').setup {
            darkvariant = "${cfg.style}",
            dim_nc_background = "${transparency}",
          }
          vim.cmd [[colorscheme rose-pine]]
        ''
        }
      '';
    }
  );
}

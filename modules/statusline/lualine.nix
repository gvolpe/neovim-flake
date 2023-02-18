{ pkgs, config, lib, ... }:

with lib;
with builtins;

let
  cfg = config.vim.statusline.lualine;
in
{
  options.vim.statusline.lualine = {
    enable = mkEnableOption "Enable lualine";

    icons = mkOption {
      type = types.bool;
      description = "Enable icons for lualine";
    };

    theme = mkOption {
      type = types.enum
        [
          "auto"
          "16color"
          "gruvbox"
          "ayu_dark"
          "ayu_light"
          "ayu_mirage"
          "codedark"
          "dracula"
          "everforest"
          "gruvbox"
          "gruvbox_light"
          "gruvbox_material"
          "horizon"
          "iceberg_dark"
          "iceberg_light"
          "jellybeans"
          "material"
          "modus_vivendi"
          "molokai"
          "nightfly"
          "nord"
          "oceanicnext"
          "onedark"
          "onelight"
          "palenight"
          "papercolor_dark"
          "papercolor_light"
          "powerline"
          "seoul256"
          "solarized_dark"
          "tomorrow"
          "wombat"
          "catppuccin"
          "tokyonight"
          "nightfox"
          "rose-pine"
          "rose-pine-alt"
        ];
      description = "Theme for lualine";
    };

    sectionSeparator = {
      left = mkOption {
        type = types.str;
        description = "Section separator for left side";
      };

      right = mkOption {
        type = types.str;
        description = "Section separator for right side";
      };
    };

    componentSeparator = {
      left = mkOption {
        type = types.str;
        description = "Component separator for left side";
      };

      right = mkOption {
        type = types.str;
        description = "Component separator for right side";
      };
    };

    activeSection = {
      a = mkOption {
        type = types.str;
        description = "active config for: | (A) | B | C       X | Y | Z |";
      };

      b = mkOption {
        type = types.str;
        description = "active config for: | A | (B) | C       X | Y | Z |";
      };

      c = mkOption {
        type = types.str;
        description = "active config for: | A | B | (C)       X | Y | Z |";
      };

      x = mkOption {
        type = types.str;
        description = "active config for: | A | B | C       (X) | Y | Z |";
      };

      y = mkOption {
        type = types.str;
        description = "active config for: | A | B | C       X | (Y) | Z |";
      };

      z = mkOption {
        type = types.str;
        description = "active config for: | A | B | C       X | Y | (Z) |";
      };
    };

    inactiveSection = {
      a = mkOption {
        type = types.str;
        description = "inactive config for: | (A) | B | C       X | Y | Z |";
      };

      b = mkOption {
        type = types.str;
        description = "inactive config for: | A | (B) | C       X | Y | Z |";
      };

      c = mkOption {
        type = types.str;
        description = "inactive config for: | A | B | (C)       X | Y | Z |";
      };

      x = mkOption {
        type = types.str;
        description = "inactive config for: | A | B | C       (X) | Y | Z |";
      };

      y = mkOption {
        type = types.str;
        description = "inactive config for: | A | B | C       X | (Y) | Z |";
      };

      z = mkOption {
        type = types.str;
        description = "inactive config for: | A | B | C       X | Y | (Z) |";
      };
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins = with pkgs.neovimPlugins; [ lualine ];
    vim.luaConfigRC = ''
      require'lualine'.setup {
        options = {
          icons_enabled = ${builtins.toString cfg.icons},
          theme = "${cfg.theme}",
          component_separators = {"${cfg.componentSeparator.left}","${cfg.componentSeparator.right}"},
          section_separators = {"${cfg.sectionSeparator.left}","${cfg.sectionSeparator.right}"},
          disabled_filetypes = {},
        },
        sections = {
          lualine_a = ${cfg.activeSection.a},
          lualine_b = ${cfg.activeSection.b},
          lualine_c = ${cfg.activeSection.c},
          lualine_x = ${cfg.activeSection.x},
          lualine_y = ${cfg.activeSection.y},
          lualine_z = ${cfg.activeSection.z},
        },
        inactive_sections = {
          lualine_a = ${cfg.inactiveSection.a},
          lualine_b = ${cfg.inactiveSection.b},
          lualine_c = ${cfg.inactiveSection.c},
          lualine_x = ${cfg.inactiveSection.x},
          lualine_y = ${cfg.inactiveSection.y},
          lualine_z = ${cfg.inactiveSection.z},
        },
        tabline = {},
        extensions = {${
        if config.vim.filetree.nvimTreeLua.enable
        then "\"nvim-tree\""
        else ""
      }},
      }
    '';
  };
}

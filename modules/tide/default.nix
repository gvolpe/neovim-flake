{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.vim.tide;
in
{
  options.vim.tide = {
    enable = mkOption {
      type = types.bool;
      description = "Enable the Tide plugin (better marks-based navigation)";
    };

    keys = {
      leader = mkOption {
        type = types.str;
        default = ";";
        description = "Leader key to prefix all Tide commands";
      };
      panel = mkOption {
        type = types.str;
        default = ";";
        description = "Open the panel (uses leader key as prefix)";
      };
      addItem = mkOption {
        type = types.str;
        default = "a";
        description = "Add new tiem to the list";
      };
      deleteItem = mkOption {
        type = types.str;
        default = "d";
        description = "Remove an tiem from the list";
      };
      clearAll = mkOption {
        type = types.str;
        default = "x";
        description = "Clear all items";
      };
      splits = {
        horizonal = mkOption {
          type = types.str;
          default = "-";
          description = "Split window horizontally";
        };
        vertical = mkOption {
          type = types.str;
          default = "|";
          description = "Split window vertically";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins = with pkgs.neovimPlugins; [ nvim-nui tide ];

    vim.luaConfigRC = ''
      require('tide').setup({
        keys = {
          leader = "${cfg.keys.leader}",
          panel = "${cfg.keys.panel}",
          add_item = "${cfg.keys.addItem}",
          delete = "${cfg.keys.deleteItem}",
          clear_all = "${cfg.keys.clearAll}",
          horizontal = "${cfg.keys.splits.horizonal}",
          vertical = "${cfg.keys.splits.vertical}",
        },
        animation_duration = 300,  -- Animation duration in milliseconds
        animation_fps = 30,        -- Frames per second for animations
      })
    '';
  };
}

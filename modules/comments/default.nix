{ pkgs, lib, config, ... }:

with lib;

let
  cfg = config.vim.comments;
in
{
  options.vim.comments = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "enable comments via kommentary";
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins = [ pkgs.neovimPlugins.kommentary ];

    vim.luaConfigRC = ''
      -- Kommentary config
      require('kommentary.config').setup();
      require('kommentary.config').configure_language("nix", {
          single_line_comment_string = "#",
      })
    '';
  };
}

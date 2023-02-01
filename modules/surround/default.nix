{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.vim.surround;
in
{
  options.vim.surround = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable nvim-surround plugin";
    };
  };

  config = mkIf cfg.enable
    {
      vim.startPlugins = [ pkgs.neovimPlugins.nvim-surround ];

      vim.luaConfigRC = ''
        require('nvim-surround').setup()
      '';

      # See: https://github.com/kylechui/nvim-surround/discussions/53#discussioncomment-3134891
      vim.runtime."ftplugin/markdown.lua".text = ''
        -- Adds "l" surround mapping for markdown links
        require('nvim-surround').buffer_setup({
          surrounds = {
            ["l"] = {
              add = function()
                local clipboard = vim.fn.getreg("+"):gsub("\n", "")
                return {
                  { "[" },
                  { "](" .. clipboard .. ")" },
                }
              end,
              find = "%b[]%b()",
              delete = "^(%[)().-(%]%b())()$",
              change = {
                target = "^()()%b[]%((.-)()%)$",
                replacement = function()
                  local clipboard = vim.fn.getreg("+"):gsub("\n", "")
                  return {
                    { "" },
                    { clipboard },
                  }
                end,
              },
            },
          }
        })
      '';
    };
}

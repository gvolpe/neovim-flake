{ pkgs, config, lib, ... }:

with lib;
with builtins;

let
  cfg = config.vim.treesitter;
in
{
  options.vim.treesitter.hlargs.enable = mkOption {
    type = types.bool;
    description = "enable highlight of used function arguments [hlargs.nvim]";
  };

  config = mkIf (cfg.enable && cfg.hlargs.enable) (
    {
      vim.startPlugins = with pkgs.neovimPlugins; [ hlargs ];

      vim.nnoremap = {
        "<leader>lha" = "<cmd> lua require('hlargs').toggle()<CR>";
      };

      vim.luaConfigRC = ''
        -- Treesitter Context config
        require'hlargs'.setup()
      '';
    }
  );
}

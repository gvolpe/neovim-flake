{ pkgs, config, lib, ... }:

with lib;
with builtins;

let
  cfg = config.vim.markdown;
in
{
  options.vim.markdown = {
    enable = mkEnableOption "markdown tools and plugins";

    glow.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable markdown preview in neovim with glow";
    };

    render.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable render-markdown.nvim plugin";
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins =
      withPlugins cfg.glow.enable [ pkgs.neovimPlugins.glow-nvim ] ++
      withPlugins cfg.render.enable [ pkgs.neovimPlugins.render-markdown-nvim ];

    vim.luaConfigRC =
      writeIf cfg.glow.enable ''
        require('glow').setup({
          glow_path = "${pkgs.glow}/bin/glow",
          border = "shadow", 
          pager = false,
          width = 120,
        })
      '' +
      writeIf cfg.render.enable ''
        require('render-markdown').setup({})
      '';

    vim.configRC =
      writeIf cfg.glow.enable ''
        autocmd FileType markdown noremap <leader>p <cmd>Glow<CR>
      '' +
      writeIf cfg.render.enable ''
        autocmd FileType markdown noremap <leader>rt <cmd>RenderMarkdown toggle<CR>
      '';
  };
}

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
      default = true;
      description = "Enable markdown preview in neovim with glow";
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins =
      withPlugins cfg.glow.enable [ pkgs.neovimPlugins.glow-nvim ];

    vim.luaConfigRC = writeIf cfg.glow.enable ''
      require('glow').setup({
        glow_path = "${pkgs.glow}/bin/glow",
        border = "shadow", 
        pager = false,
        width = 120,
      })
    '';

    vim.configRC =
      writeIf cfg.glow.enable ''
        autocmd FileType markdown noremap <leader>p :Glow<CR>
      '';
  };
}

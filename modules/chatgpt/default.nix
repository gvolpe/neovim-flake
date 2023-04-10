{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.vim.chatgpt;
in
{
  options.vim.chatgpt = {
    enable = mkOption {
      type = types.bool;
      description = "Enable ChatGPT.nvim plugin";
    };
    openaiApiKey = mkOption {
      default = null;
      description = "The OpenAI API KEY (can also be set as an env variable)";
      type = types.nullOr types.str;
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins = with pkgs.neovimPlugins; [ nvim-nui nvim-chatgpt ];

    vim.luaConfigRC = ''
      require("chatgpt").setup({
        ${if cfg.openaiApiKey != null then ''openai_api_key = "${cfg.openaiApiKey}"'' else ""}
      })
    '';
  };
}

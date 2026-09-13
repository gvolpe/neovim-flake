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
    openaiApiKeyPath = mkOption {
      description = "The OpenAI API KEY runtime path (e.g. `config.age.secrets.openai-api-key.path`)";
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins = with pkgs.neovimPlugins; [ nvim-nui nvim-chatgpt ];

    vim.startLuaConfigRC = ''
      -- ChatGPT api key
      do
        local function expand_env(path)
          local function replace(name)
            return vim.env[name] or os.getenv(name) or ("$" .. "{" .. name .. "}")
          end

          return path
            :gsub("[$]{([%w_]+)}", replace)
            :gsub("[$]([%w_]+)", replace)
        end

        local file = io.open(expand_env("${cfg.openaiApiKeyPath}"), "r")
        local api_key = ""

        if file then
          api_key = file:read("*a") or ""
          file:close()
        end

        vim.env.OPENAI_API_KEY = vim.trim(api_key)
      end
    '';

    vim.luaConfigRC = ''
      require("chatgpt").setup({})
    '';
  };
}

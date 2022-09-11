{ pkgs, config, lib, ... }:

with lib;
with builtins;

let
  cfg = config.vim.todo;
in
{
  options.vim.todo = {
    enable = mkEnableOption "todo-comments";
  };

  config = mkIf (cfg.enable) {
    vim.startPlugins = [ pkgs.neovimPlugins.todo-comments ];

    vim.luaConfigRC = ''
      require('todo-comments').setup {
        highlight = {
          before = "", -- "fg" or "bg" or empty
          keyword = "bg", -- "fg", "bg", "wide" or empty
          after = "fg", -- "fg" or "bg" or empty
          pattern = [[.*<(KEYWORDS)(\([^\)]*\))?:]],
          comments_only = true, -- uses treesitter to match keywords in comments only
          max_line_len = 400, -- ignore lines longer than this
          exclude = {}, -- list of file types to exclude highlighting
        },

        search = {
          command = "${pkgs.ripgrep}/bin/rg",
          args = {
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
          },
          pattern = [[\b(KEYWORDS)(\([^\)]*\))?:]],
        },
      }
    '';
  };
}


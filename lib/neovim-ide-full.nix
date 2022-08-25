{ pkgs, neovimBuilder, ... }:

# configuration with sane defaults to use directly via nix run
neovimBuilder {
  config = {
    vim.viAlias = false;
    vim.vimAlias = true;
    vim.customPlugins = with pkgs.vimPlugins; [
      multiple-cursors
      vim-repeat
      vim-surround
    ];
    vim.lsp = {
      enable = true;
      formatOnSave = false;
      lightbulb.enable = true;
      lspsaga.enable = false;
      nvimCodeActionMenu.enable = true;
      trouble.enable = true;
      lspSignature.enable = true;
      rust.enable = false;
      nix = true;
      dhall = true;
      elm = true;
      haskell = true;
      scala = true;
      sql = true;
      python = false;
      clang = false;
      ts = false;
      go = false;
    };
    vim.visuals = {
      enable = true;
      nvimWebDevicons.enable = true;
      lspkind.enable = true;
      indentBlankline = {
        enable = true;
        fillChar = "";
        eolChar = "";
        showCurrContext = true;
      };
      cursorWordline = {
        enable = true;
        lineTimeout = 0;
      };
    };
    vim.statusline.lualine = {
      enable = true;
      theme = "onedark";
    };
    vim.theme = {
      enable = true;
      name = "onedark";
      style = "darker";
      transparency = true;
    };
    vim.autopairs.enable = true;
    vim.autocomplete = {
      enable = true;
      type = "nvim-cmp";
    };
    vim.filetree.nvimTreeLua = {
      enable = true;
      hideDotFiles = false;
      hideFiles = [ "node_modules" ".cache" ];
    };
    vim.tabline.nvimBufferline.enable = true;
    vim.treesitter = {
      enable = true;
      autotagHtml = true;
      context.enable = true;
    };
    vim.scala = {
      highlightMode = "regex";
    };
    vim.keys = {
      enable = true;
      whichKey.enable = true;
    };
    vim.comments = {
      enable = true;
      type = "nerdcommenter";
    };
    vim.shortcuts = {
      enable = true;
    };
    vim.telescope = {
      enable = true;
    };
    vim.markdown = {
      enable = true;
      glow.enable = true;
    };
    vim.git = {
      enable = true;
      gitsigns.enable = true;
    };
  };
}

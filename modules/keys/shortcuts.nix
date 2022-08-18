{ pkgs
, config
, lib
, ...
}:
with lib;

let
  cfg = config.vim.shortcuts;
in
{
  options.vim.shortcuts = {
    enable = mkEnableOption "enable shortcuts";
  };

  config = mkIf cfg.enable {
    vim.nnoremap =
      {
        "<C-p>" = "<cmd> Telescope find_files<CR>";
        "<C-s>" = "<cmd> NvimTreeFindFile<CR>";
        "<C-F>" = "<cmd> NvimTreeToggle<CR>";

        # Disable the annoying and useless ex-mode
        "gQ" = "<nop>";

        ### Handle window actions with Meta instead of <C-w>
        # Switching
        "<M-h>" = "<C-w>h";
        "<M-j>" = "<C-w>j";
        "<M-k>" = "<C-w>k";
        "<M-l>" = "<C-w>l";

        # Moving
        "<M-H>" = "<C-w>H";
        "<M-J>" = "<C-w>J";
        "<M-K>" = "<C-w>K";
        "<M-L>" = "<C-w>L";
        "<M-x>" = "<C-w>x";

        # Resizing
        "<M-=>" = "<C-w>=";
        "<M-+>" = "<C-w>+";
        "<M-->" = "<C-w>-";
        "<M-<>" = "<C-w><";
        "<M->>" = "<C-w>>";
      }
      // (
        if config.vim.lsp.enable
        then { }
        else { }
      )
      // (
        if config.vim.treesitter.enable
        then { }
        else { }
      );
  };
}


{ pkgs, config, lib, ... }:

with lib;
with builtins;

let
  cfg = config.vim.filetree.nvimTreeLua;
in
{
  options.vim.filetree.nvimTreeLua = {
    enable = mkEnableOption "Enable nvim-tree-lua";

    treeSide = mkOption {
      default = "left";
      description = "Side the tree will appear on left or right";
      type = types.enum [ "left" "right" ];
    };

    treeWidth = mkOption {
      default = 25;
      description = "Width of the tree in charecters";
      type = types.int;
    };

    hideFiles = mkOption {
      default = [ ".git" "node_modules" ".cache" ];
      description = "Files to hide in the file view by default.";
      type = with types; listOf str;
    };

    hideIgnoredGitFiles = mkOption {
      default = false;
      description = "Hide files ignored by git";
      type = types.bool;
    };

    openOnSetup = mkOption {
      default = true;
      description = "Open when vim is started on a directory";
      type = types.bool;
    };

    closeOnLastWindow = mkOption {
      default = true;
      description = "Close when tree is last window open";
      type = types.bool;
    };

    ignoreFileTypes = mkOption {
      default = [ ];
      description = "Ignore file types";
      type = with types; listOf str;
    };

    closeOnFileOpen = mkOption {
      default = false;
      description = "Close the tree when a file is opened";
      type = types.bool;
    };

    resizeOnFileOpen = mkOption {
      default = false;
      description = "Resize the tree window when a file is opened";
      type = types.bool;
    };

    followBufferFile = mkOption {
      default = true;
      description = "Follow file that is in current buffer on tree";
      type = types.bool;
    };

    indentMarkers = mkOption {
      default = true;
      description = "Show indent markers";
      type = types.bool;
    };

    hideDotFiles = mkOption {
      default = false;
      description = "Hide dotfiles";
      type = types.bool;
    };

    openTreeOnNewTab = mkOption {
      default = false;
      description = "Opens the tree view when opening a new tab";
      type = types.bool;
    };

    disableNetRW = mkOption {
      default = false;
      description = "Disables netrw and replaces it with tree";
      type = types.bool;
    };

    hijackNetRW = mkOption {
      default = true;
      description = "Prevents netrw from automatically opening when opening directories";
      type = types.bool;
    };

    trailingSlash = mkOption {
      default = true;
      description = "Add a trailing slash to all folders";
      type = types.bool;
    };

    groupEmptyFolders = mkOption {
      default = true;
      description = "Compact empty folders trees into a single item";
      type = types.bool;
    };

    lspDiagnostics = mkOption {
      default = true;
      description = "Shows lsp diagnostics in the tree";
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins = with pkgs.neovimPlugins; [
      nvim-tree-lua
    ];

    vim.nnoremap = {
      "<C-F>" = ":NvimTreeToggle<CR>";
      "<C-s>" = ":NvimTreeFindFile<CR>";
      "<leader>tr" = ":NvimTreeRefresh<CR>";
    };

    vim.luaConfigRC = ''
      require'nvim-tree'.setup({
        disable_netrw = ${boolToString cfg.disableNetRW},
        hijack_netrw = ${boolToString cfg.hijackNetRW},
        open_on_tab = ${boolToString cfg.openTreeOnNewTab},
        open_on_setup = ${boolToString cfg.openOnSetup},
        diagnostics = {
          enable = ${boolToString cfg.lspDiagnostics},
        },
        view  = {
          width = ${toString cfg.treeWidth},
          side = ${"'" + cfg.treeSide + "'"},
        },
        renderer = {
          add_trailing = ${boolToString cfg.trailingSlash},
          group_empty = ${boolToString cfg.groupEmptyFolders},
          indent_markers = {
            enable = ${boolToString cfg.indentMarkers},
          },
        },
        actions = {
          open_file = {
            quit_on_open = ${boolToString cfg.closeOnFileOpen},
            resize_window = ${boolToString cfg.resizeOnFileOpen}
          },
        },
        git = {
          enable = true,
          ignore = ${boolToString cfg.hideIgnoredGitFiles},
        },
        filters = {
          dotfiles = ${boolToString cfg.hideDotFiles},
          custom = {
            ${builtins.concatStringsSep "\n" (builtins.map (s: "\"" + s + "\",") cfg.hideFiles)}
          },
        },
      })
    '';
  };
}

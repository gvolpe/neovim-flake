{ pkgs, lib, neovimBuilder, ... }:

let
  deepMerge = lib.attrsets.recursiveUpdate;

  cfg = {
    vim = {
      viAlias = false;
      vimAlias = true;
      preventJunkFiles = true;
      cmdHeight = 2;
      customPlugins = with pkgs.vimPlugins; [
        multiple-cursors
        vim-repeat
        vim-surround
      ];
      lsp = {
        enable = true;
        folds = true;
        formatOnSave = false;
        lightbulb.enable = true;
        lspsaga.enable = false;
        nvimCodeActionMenu.enable = true;
        trouble.enable = true;
        lspSignature.enable = true;
        scala = {
          enable = true;
          metals = pkgs.metals;
          type = "nvim-metals";
        };
        nix = {
          enable = true;
          type = "nil";
        };
        rust.enable = false;
        ts = false;
        smithy = false;
        dhall = false;
        elm = false;
        haskell = false;
        sql = false;
        python = false;
        clang = false;
        go = false;
      };
      plantuml.enable = false;
      visuals = {
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
      statusline.lualine = {
        enable = true;
        theme = "onedark";
      };
      theme = {
        enable = true;
        name = "onedark";
        style = "deep";
        transparency = true;
      };
      autopairs.enable = true;
      autocomplete = {
        enable = true;
        type = "nvim-cmp";
      };
      filetree.nvimTreeLua = {
        enable = true;
        hideDotFiles = false;
        hideFiles = [ "node_modules" ".cache" ];
      };
      tabline.nvimBufferline.enable = true;
      treesitter = {
        enable = true;
        autotagHtml = true;
        context.enable = true;
      };
      scala = {
        highlightMode = "treesitter";
      };
      keys = {
        enable = true;
        whichKey.enable = true;
      };
      comments = {
        enable = true;
        type = "nerdcommenter";
      };
      shortcuts = {
        enable = true;
      };
      telescope = {
        enable = true;
      };
      markdown = {
        enable = true;
        glow.enable = true;
      };
      git = {
        enable = true;
        gitsigns.enable = true;
      };
      mind = {
        enable = false;
        persistence = {
          dataDir = "~/.local/share/mind.nvim/data";
          statePath = "~/.local/share/mind.nvim/mind.json";
        };
      };
      hop.enable = true;
      todo.enable = true;
    };
  };

  langs = {
    vim.lsp = {
      ts = true;
      smithy = true;
      dhall = true;
      elm = true;
    };
  };

  haskell-lsp = {
    vim.lsp = {
      haskell = true;
    };
  };

  rose-pine = {
    vim = {
      statusline.lualine = {
        enable = true;
        theme = "rose-pine";
      };
      theme = {
        enable = true;
        name = "rose-pine";
        style = "moon";
        transparency = false;
      };
    };
  };

  tokyo-night = {
    vim = {
      statusline.lualine = {
        enable = true;
        theme = "tokyonight";
      };
      theme = {
        enable = true;
        name = "tokyonight";
        style = "storm";
        transparency = false;
      };
    };
  };
in
{
  full = neovimBuilder {
    config = deepMerge cfg langs;
  };

  haskell = neovimBuilder {
    config = deepMerge cfg haskell-lsp;
  };

  scala = neovimBuilder { config = cfg; };

  scala-rose-pine = neovimBuilder {
    config = deepMerge cfg rose-pine;
  };

  scala-tokyo-night = neovimBuilder {
    config = deepMerge cfg tokyo-night;
  };
}

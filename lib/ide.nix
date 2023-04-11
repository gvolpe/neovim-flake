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
          inherit (pkgs) metals;
          enable = true;
        };
        nix = {
          enable = true;
          type = "nil";
        };
        rust.enable = false;
        ts = false;
        smithy.enable = false;
        dhall = false;
        elm = false;
        haskell = false;
        sql = false;
        python = false;
        clang = false;
        go = false;
      };
      plantuml.enable = false;
      fx.automaton.enable = true;
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
      neoclip.enable = true;
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
      surround = {
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
      chatgpt = {
        enable = false;
        openaiApiKey = null;
      };
      spider = {
        enable = true;
        skipInsignificantPunctuation = true;
      };
      dial.enable = true;
      hop.enable = true;
      notifications.enable = true;
      todo.enable = true;
    };
  };

  langs = {
    vim.lsp = {
      ts = true;
      smithy.enable = true;
      dhall = true;
      elm = true;
    };
  };

  haskell-lsp = {
    vim.lsp = {
      haskell = true;
    };
  };

  nightly = {
    vim.neovim.package = pkgs.neovim-nightly;
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
    config = deepMerge (deepMerge cfg langs) nightly;
  };

  full-nightly = neovimBuilder {
    config = deepMerge cfg langs;
  };

  haskell = neovimBuilder {
    config = deepMerge cfg haskell-lsp;
  };

  scala = neovimBuilder { config = cfg; };

  scala-nightly = neovimBuilder {
    config = deepMerge cfg nightly;
  };

  scala-rose-pine = neovimBuilder {
    config = deepMerge cfg rose-pine;
  };

  scala-tokyo-night = neovimBuilder {
    config = deepMerge cfg tokyo-night;
  };
}

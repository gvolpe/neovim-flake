{
  description = "Jordan's Neovim Configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    jdpkgs = {
      url = "github:jordanisaacs/jdpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # LSP plugins
    nvim-lspconfig = {
      url = "github:neovim/nvim-lspconfig?ref=v0.1.3";
      flake = false;
    };
    nvim-treesitter = {
      url = "github:nvim-treesitter/nvim-treesitter";
      flake = false;
    };
    lspsaga = {
      url = "github:tami5/lspsaga.nvim";
      flake = false;
    };
    lspkind = {
      url = "github:onsails/lspkind-nvim";
      flake = false;
    };
    trouble = {
      url = "github:folke/trouble.nvim";
      flake = false;
    };
    nvim-treesitter-context = {
      url = "github:lewis6991/nvim-treesitter-context";
      flake = false;
    };
    nvim-lightbulb = {
      url = "github:kosayoda/nvim-lightbulb";
      flake = false;
    };

    nvim-code-action-menu = {
      url = "github:weilbith/nvim-code-action-menu";
      flake = false;
    };
    lsp-signature = {
      url = "github:ray-x/lsp_signature.nvim";
      flake = false;
    };
    null-ls = {
      url = "github:jose-elias-alvarez/null-ls.nvim";
      flake = false;
    };
    sqls-nvim = {
      url = "github:nanotee/sqls.nvim";
      flake = false;
    };
    rust-tools = {
      url = "github:simrat39/rust-tools.nvim";
      flake = false;
    };

    # Copying/Registers
    registers = {
      url = "github:tversteeg/registers.nvim";
      flake = false;
    };
    nvim-neoclip = {
      url = "github:AckslD/nvim-neoclip.lua";
      flake = false;
    };

    # Telescope
    telescope = {
      url = "github:nvim-telescope/telescope.nvim";
      flake = false;
    };

    # Langauge server (use master instead of nixpkgs)
    rnix-lsp.url = "github:nix-community/rnix-lsp";

    # Filetrees
    nvim-tree-lua = {
      url = "github:kyazdani42/nvim-tree.lua";
      flake = false;
    };

    # Tablines
    nvim-bufferline-lua = {
      url = "github:akinsho/nvim-bufferline.lua?ref=v1.2.0";
      flake = false;
    };

    # Statuslines
    lualine = {
      url = "github:hoob3rt/lualine.nvim";
      flake = false;
    };

    # Autocompletes
    nvim-compe = {
      url = "github:hrsh7th/nvim-compe";
      flake = false;
    };
    nvim-cmp = {
      url = "github:hrsh7th/nvim-cmp";
      flake = false;
    };
    cmp-buffer = {
      url = "github:hrsh7th/cmp-buffer";
      flake = false;
    };
    cmp-nvim-lsp = {
      url = "github:hrsh7th/cmp-nvim-lsp";
      flake = false;
    };
    cmp-vsnip = {
      url = "github:hrsh7th/cmp-vsnip";
      flake = false;
    };
    cmp-path = {
      url = "github:hrsh7th/cmp-path";
      flake = false;
    };
    cmp-treesitter = {
      url = "github:ray-x/cmp-treesitter";
      flake = false;
    };

    # snippets
    vim-vsnip = {
      url = "github:hrsh7th/vim-vsnip";
      flake = false;
    };

    # Autopairs
    nvim-autopairs = {
      url = "github:windwp/nvim-autopairs";
      flake = false;
    };
    nvim-ts-autotag = {
      url = "github:windwp/nvim-ts-autotag";
      flake = false;
    };

    # Commenting
    kommentary = {
      url = "github:b3nj5m1n/kommentary";
      flake = false;
    };
    todo-comments = {
      url = "github:folke/todo-comments.nvim";
      flake = false;
    };

    # Buffer tools
    bufdelete-nvim = {
      url = "github:famiu/bufdelete.nvim";
      flake = false;
    };

    # Themes
    tokyonight = {
      url = "github:folke/tokyonight.nvim";
      flake = false;
    };

    onedark = {
      url = "github:navarasu/onedark.nvim";
      flake = false;
    };

    # Rust crates
    crates-nvim = {
      url = "github:Saecki/crates.nvim";
      flake = false;
    };

    # Visuals
    nvim-cursorline = {
      url = "github:yamatsum/nvim-cursorline";
      flake = false;
    };
    indent-blankline = {
      url = "github:lukas-reineke/indent-blankline.nvim";
      flake = false;
    };
    nvim-web-devicons = {
      url = "github:kyazdani42/nvim-web-devicons";
      flake = false;
    };
    gitsigns-nvim = {
      url = "github:lewis6991/gitsigns.nvim";
      flake = false;
    };

    # Key binding help
    which-key = {
      url = "github:folke/which-key.nvim";
      flake = false;
    };

    # Markdown
    glow-nvim = {
      url = "github:ellisonleao/glow.nvim";
      flake = false;
    };

    # Plenary (required by crates-nvim)
    plenary-nvim = {
      url = "github:nvim-lua/plenary.nvim";
      flake = false;
    };

    hare-vim = {
      url = "git+https://git.sr.ht/~sircmpwn/hare.vim";
      flake = false;
    };

    tree-sitter-hare = {
      url = "git+https://git.sr.ht/~ecmma/tree-sitter-hare";
      flake = false;
    };
  };

  outputs = {
    nixpkgs,
    jdpkgs,
    flake-utils,
    ...
  } @ inputs: flake-utils.lib.eachDefaultSystem (system: let
    # Plugin must be same as input name
    plugins = [
      "nvim-treesitter-context"
      "gitsigns-nvim"
      "plenary-nvim"
      "nvim-lspconfig"
      "nvim-treesitter"
      "lspsaga"
      "lspkind"
      "nvim-lightbulb"
      "lsp-signature"
      "nvim-tree-lua"
      "nvim-bufferline-lua"
      "lualine"
      "nvim-compe"
      "nvim-autopairs"
      "nvim-ts-autotag"
      "nvim-web-devicons"
      "tokyonight"
      "bufdelete-nvim"
      "nvim-cmp"
      "cmp-nvim-lsp"
      "cmp-buffer"
      "cmp-vsnip"
      "cmp-path"
      "cmp-treesitter"
      "crates-nvim"
      "vim-vsnip"
      "nvim-code-action-menu"
      "trouble"
      "null-ls"
      "which-key"
      "indent-blankline"
      "nvim-cursorline"
      "sqls-nvim"
      "glow-nvim"
      "telescope"
      "rust-tools"
      "onedark"
      "hare-vim"
    ];

    pluginOverlay = lib.buildPluginOverlay;

    metalsOverlay = (f: p: {
      metals = p.metals.overrideAttrs (old: rec {
        version = "0.11.8";
        extraJavaOpts = old.extraJavaOpts + " -Dmetals.client=nvim-lsp";
        deps = old.deps.overrideAttrs (do: {
          outputHash = "sha256-Zc/0kod3JM58WpyxwXiyQdixBHOJV7UDGg1YZtHJ3hw=";
        });
      });
    });

    macIntelOverlay = (self: super:
      if super.stdenv.isDarwin && super.stdenv.isAarch64 then
        let intelPkgs = nixpkgs.legacyPackages.x86_64-darwin;
        in {
          inherit
            (intelPkgs)
            llvmPackages_6
            llvmPackages_7
            llvmPackages_8
            llvmPackages_9
            llvmPackages_10;
        } else {});

    pkgs = import nixpkgs {
      inherit system;
      config = {allowUnfree = true;};
      overlays = [
        macIntelOverlay
        pluginOverlay
        metalsOverlay
        (f: p: {
          rnix-lsp = inputs.rnix-lsp.defaultPackage.${system};
          # tree-sitter-hare = jdpkgs.packages.${system}.tree-sitter-hare;
        })
      ];
    };

    lib =
      import
      ./lib
      {inherit pkgs inputs plugins;};

    neovimBuilder = lib.neovimBuilder;
  in rec {
    apps = rec {
      nvim = {
        type = "app";
        program = "${packages.default}/bin/nvim";
      };

      default = nvim;
    };

    devShells.default = pkgs.mkShell {
      buildInputs = [packages.neovimmer];
    };

    overlays.default = final: prev: {
      inherit neovimBuilder;
      neovimmer = packages.neovimmer;
      neovimPlugins = pkgs.neovimPlugins;
    };

    packages = rec {
      default = neovimmer;
      neovimmer = neovimBuilder {
        config = {
          vim.viAlias = false;
          vim.vimAlias = true;
          vim.lsp = {
            enable = true;
            formatOnSave = true;
            lightbulb.enable = true;
            lspsaga.enable = false;
            nvimCodeActionMenu.enable = true;
            trouble.enable = true;
            lspSignature.enable = true;
            rust.enable = false;
            nix = true;
            dhall = false;
            elm = false;
            haskell = false;
            scala = true;
            sql = true;
            python = false;
            clang = false;
            ts = false;
            go = false;
            hare = false;
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
          };
          vim.autopairs.enable = true;
          vim.autocomplete = {
            enable = true;
            type = "nvim-cmp";
          };
          vim.filetree.nvimTreeLua.enable = true;
          vim.tabline.nvimBufferline.enable = true;
          vim.treesitter = {
            enable = true;
            autotagHtml = true;
            context.enable = true;
          };
          vim.keys = {
            enable = true;
            whichKey.enable = true;
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
      };
    };
  });
}

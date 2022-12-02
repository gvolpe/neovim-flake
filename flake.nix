{
  description = "gvolpe's Neovim Configuration";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixpkgs-unstable;

    # LSP plugins
    nvim-lspconfig = {
      url = github:neovim/nvim-lspconfig?ref=v0.1.3;
      flake = false;
    };
    nvim-treesitter = {
      url = github:nvim-treesitter/nvim-treesitter;
      flake = false;
    };
    lspsaga = {
      url = github:tami5/lspsaga.nvim;
      flake = false;
    };
    lspkind = {
      url = github:onsails/lspkind-nvim;
      flake = false;
    };
    trouble = {
      url = github:folke/trouble.nvim;
      flake = false;
    };
    nvim-treesitter-context = {
      url = github:lewis6991/nvim-treesitter-context;
      flake = false;
    };
    nvim-lightbulb = {
      url = github:kosayoda/nvim-lightbulb;
      flake = false;
    };

    nvim-code-action-menu = {
      url = github:weilbith/nvim-code-action-menu;
      flake = false;
    };
    lsp-signature = {
      url = github:ray-x/lsp_signature.nvim;
      flake = false;
    };
    null-ls = {
      url = github:jose-elias-alvarez/null-ls.nvim;
      flake = false;
    };
    sqls-nvim = {
      url = github:nanotee/sqls.nvim;
      flake = false;
    };
    rust-tools = {
      url = github:simrat39/rust-tools.nvim;
      flake = false;
    };
    nvim-metals = {
      url = github:scalameta/nvim-metals;
      flake = false;
    };

    # Copying/Registers
    registers = {
      url = github:tversteeg/registers.nvim;
      flake = false;
    };
    nvim-neoclip = {
      url = github:AckslD/nvim-neoclip.lua;
      flake = false;
    };

    # Folds 
    nvim-ufo = {
      url = github:kevinhwang91/nvim-ufo;
      flake = false;
    };

    promise-async = {
      url = github:kevinhwang91/promise-async; # required by nvim-ufo
      flake = false;
    };

    # Telescope
    telescope = {
      url = github:nvim-telescope/telescope.nvim;
      flake = false;
    };

    # Filetrees
    nvim-tree-lua = {
      url = github:kyazdani42/nvim-tree.lua;
      flake = false;
    };

    # Tablines
    nvim-bufferline-lua = {
      url = github:akinsho/nvim-bufferline.lua?ref=v1.2.0;
      flake = false;
    };

    # Statuslines
    lualine = {
      url = github:hoob3rt/lualine.nvim;
      flake = false;
    };

    # Autocompletes
    nvim-compe = {
      url = github:hrsh7th/nvim-compe;
      flake = false;
    };
    nvim-cmp = {
      url = github:hrsh7th/nvim-cmp;
      flake = false;
    };
    cmp-buffer = {
      url = github:hrsh7th/cmp-buffer;
      flake = false;
    };
    cmp-nvim-lsp = {
      url = github:hrsh7th/cmp-nvim-lsp;
      flake = false;
    };
    cmp-vsnip = {
      url = github:hrsh7th/cmp-vsnip;
      flake = false;
    };
    cmp-path = {
      url = github:hrsh7th/cmp-path;
      flake = false;
    };
    cmp-treesitter = {
      url = github:ray-x/cmp-treesitter;
      flake = false;
    };

    # Snippets
    vim-vsnip = {
      url = github:hrsh7th/vim-vsnip;
      flake = false;
    };

    # Autopairs
    nvim-autopairs = {
      url = github:windwp/nvim-autopairs;
      flake = false;
    };
    nvim-ts-autotag = {
      url = github:windwp/nvim-ts-autotag;
      flake = false;
    };

    # Commenting
    kommentary = {
      url = github:b3nj5m1n/kommentary;
      flake = false;
    };
    todo-comments = {
      url = github:folke/todo-comments.nvim;
      flake = false;
    };

    # Buffer tools
    bufdelete-nvim = {
      url = github:famiu/bufdelete.nvim;
      flake = false;
    };

    hop = {
      url = github:phaazon/hop.nvim;
      flake = false;
    };

    # Themes
    catppuccin = {
      url = github:catppuccin/nvim;
      flake = false;
    };

    nightfox = {
      url = github:EdenEast/nightfox.nvim;
      flake = false;
    };

    onedark = {
      url = github:navarasu/onedark.nvim;
      flake = false;
    };

    tokyonight = {
      url = github:folke/tokyonight.nvim;
      flake = false;
    };

    # Rust crates
    crates-nvim = {
      url = github:Saecki/crates.nvim;
      flake = false;
    };

    # Visuals
    nvim-cursorline = {
      url = github:yamatsum/nvim-cursorline;
      flake = false;
    };
    indent-blankline = {
      url = github:lukas-reineke/indent-blankline.nvim;
      flake = false;
    };
    nvim-web-devicons = {
      url = github:kyazdani42/nvim-web-devicons;
      flake = false;
    };
    gitsigns-nvim = {
      url = github:lewis6991/gitsigns.nvim;
      flake = false;
    };

    # Key binding help
    which-key = {
      url = github:folke/which-key.nvim;
      flake = false;
    };

    # Markdown
    glow-nvim = {
      url = github:ellisonleao/glow.nvim;
      flake = false;
    };

    # Organized notes in trees
    mind-nvim = {
      url = github:gvolpe/mind.nvim;
      #url = github:phaazon/mind.nvim;
      flake = false;
    };

    # Plenary (required by crates-nvim)
    plenary-nvim = {
      url = github:nvim-lua/plenary.nvim;
      flake = false;
    };

    # Scala 3 highlights (treesitter doesn't yet support it)
    vim-scala = {
      url = github:gvolpe/vim-scala;
      flake = false;
    };

    vim-smithy = {
      url = github:jasdel/vim-smithy;
      flake = false;
    };
  };

  outputs = inputs @ { self, nixpkgs, flake-utils, ... }:
    let
      system = "x86_64-linux";

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
        "nightfox"
        "catppuccin"
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
        "kommentary"
        "hop"
        "nvim-metals"
        "todo-comments"
        "nvim-ufo"
        "promise-async"
        "mind-nvim"
        "vim-smithy"
      ];

      lib = import ./lib { inherit pkgs inputs plugins; };

      pluginOverlay = lib.buildPluginOverlay;
      metalsOverlay = lib.metalsOverlay;

      libOverlay = f: p: {
        lib = p.lib.extend (_: _: {
          inherit (lib) mkVimBool withAttrSet withPlugins writeIf;
        });
      };

      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
        overlays = [ libOverlay pluginOverlay metalsOverlay ];
      };

      metalsBuilder = lib.metalsBuilder;
      neovimBuilder = lib.neovimBuilder;

      neovim-ide-full = import ./lib/neovim-ide-full.nix {
        inherit pkgs neovimBuilder;
      };
    in
    rec {
      apps.${system} = rec {
        nvim = {
          type = "app";
          program = "${packages.${system}.default}/bin/nvim";
        };

        default = nvim;
      };

      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [ packages.${system}.neovim-ide ];
      };

      overlays.default = f: p: {
        inherit metalsBuilder neovimBuilder neovim-ide-full;
        neovimPlugins = pkgs.neovimPlugins;
      };

      nixosModules.hm = {
        imports = [
          ./lib/hm.nix
          { nixpkgs.overlays = [ self.overlays.default ]; }
        ];
      };

      packages.${system} = rec {
        default = neovim-ide;
        metals = pkgs.metals;
        neovim-ide = neovim-ide-full;
      };
    };
}

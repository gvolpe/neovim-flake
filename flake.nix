{
  description = "Neovim Flake by Gabriel Volpe";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixpkgs-unstable;
    flake-utils.url = github:numtide/flake-utils;

    # Nix module docs generator
    nmd.url = github:gvolpe/nmd;
    #nmd.url = git+file:///home/gvolpe/workspace/nmd;

    # LSP plugins
    nvim-lspconfig = {
      url = github:neovim/nvim-lspconfig;
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
    nvim-bufferline = {
      url = github:akinsho/bufferline.nvim;
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

    rosepine = {
      url = github:rose-pine/neovim;
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

    # Plant UML syntax highlights
    vim-plantuml = {
      url = github:aklt/plantuml-syntax;
      flake = false;
    };

    # custom tree-sitter grammar
    ts-build.url = github:pta2002/build-ts-grammar.nix;

    tree-sitter-scala = {
      url = github:tree-sitter/tree-sitter-scala;
      flake = false;
    };
  };

  outputs = inputs @ { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
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
          "nvim-bufferline"
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
          "vim-plantuml"
          "rosepine"
        ];

        lib = import ./lib { inherit pkgs inputs plugins; };

        pluginOverlay = lib.buildPluginOverlay;
        metalsOverlay = lib.metalsOverlay;
        nmdOverlay = inputs.nmd.overlays.default;

        libOverlay = f: p: {
          lib = p.lib.extend (_: _: {
            inherit (lib) mkVimBool withAttrSet withPlugins writeIf;
          });
        };

        pkgs = import nixpkgs {
          inherit system;
          config = { allowUnfree = true; };
          overlays = [ libOverlay pluginOverlay metalsOverlay nmdOverlay ];
        };

        metalsBuilder = lib.metalsBuilder;
        neovimBuilder = lib.neovimBuilder;

        default-ide = pkgs.callPackage ./lib/ide.nix {
          inherit pkgs neovimBuilder;
        };

        searchdocs = pkgs.callPackage ./docs/search { };

        docbook = with import ./docs { inherit pkgs; lib = pkgs.lib; }; {
          html = manual.html;
          manPages = manPages;
          json = options.json;
          jsonModuleMaintainers = jsonModuleMaintainers;
        };
      in
      rec {
        apps = rec {
          nvim = {
            type = "app";
            program = "${packages.default}/bin/nvim";
          };

          default = nvim;
        };

        devShells.default = pkgs.mkShell {
          buildInputs = [ packages.neovim-ide ];
        };

        overlays.default = f: p: {
          inherit metalsBuilder neovimBuilder;
          neovimPlugins = pkgs.neovimPlugins;
        };

        nixosModules.hm = {
          imports = [
            ./lib/hm.nix
            { nixpkgs.overlays = [ overlays.default ]; }
          ];
        };

        packages = {
          default = default-ide.full;

          # Documentation
          docs = docbook.html;
          docs-json = searchdocs.json;
          docs-search = searchdocs.html;

          # CI package
          metals = pkgs.metals;

          # Main languages enabled
          ide = default-ide.full;

          # Only Scala with different themes
          scala = default-ide.scala;
          scala-rose-pine = default-ide.scala-rose-pine;
          scala-tokyo-night = default-ide.scala-tokyo-night;
        };
      }
    );
}

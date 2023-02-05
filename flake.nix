{
  description = "Neovim Flake by Gabriel Volpe";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixpkgs-unstable;
    flake-utils.url = github:numtide/flake-utils;

    # Temporary pin: https://github.com/nix-community/neovim-nightly-overlay/issues/164
    nixpkgs-neovim.url = github:nixos/nixpkgs?rev=fad51abd42ca17a60fc1d4cb9382e2d79ae31836;
    neovim-nightly-flake.url = "github:neovim/neovim?dir=contrib";
    neovim-nightly-flake.inputs.nixpkgs.follows = "nixpkgs-neovim";

    # Nix module docs generator
    nmd.url = github:gvolpe/nmd;
    #nmd.url = git+file:///home/gvolpe/workspace/nmd;

    # Custom tree-sitter grammar
    ts-build.url = github:pta2002/build-ts-grammar.nix;

    tree-sitter-scala = {
      url = github:tree-sitter/tree-sitter-scala;
      flake = false;
    };

    tree-sitter-typescript = {
      url = github:tree-sitter/tree-sitter-typescript;
      flake = false;
    };

    # Neovim plugins

    # Text objects
    nvim-surround = {
      url = github:kylechui/nvim-surround;
      flake = false;
    };

    # Copying/Registers
    nvim-neoclip = {
      url = github:AckslD/nvim-neoclip.lua;
      flake = false;
    };

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

    # Fx
    cellular-automaton = {
      url = github:Eandrju/cellular-automaton.nvim;
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

    # Plant UML syntax highlights
    vim-plantuml = {
      url = github:aklt/plantuml-syntax;
      flake = false;
    };
  };

  outputs = inputs @ { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        plugins =
          let
            f = xs: pkgs.lib.attrsets.filterAttrs (k: v: !builtins.elem k xs);

            nonPluginInputNames = [
              "self"
              "nixpkgs"
              "flake-utils"
              "nixpkgs-neovim"
              "neovim-nightly-flake"
              "nmd"
              "ts-build"
              "tree-sitter-scala"
              "tree-sitter-typescript"
            ];
          in
          builtins.attrNames (f nonPluginInputNames inputs);

        lib = import ./lib { inherit pkgs inputs plugins; };

        inherit (lib) metalsBuilder metalsOverlay neovimBuilder;

        pluginOverlay = lib.buildPluginOverlay;
        nmdOverlay = inputs.nmd.overlays.default;

        libOverlay = f: p: {
          lib = p.lib.extend (_: _: {
            inherit (lib) mkVimBool withAttrSet withPlugins writeIf;
          });
        };

        tsOverlay = f: p: {
          tree-sitter-scala-master = inputs.ts-build.lib.buildGrammar p {
            language = "scala";
            version = "${inputs.tree-sitter-scala.version}-${inputs.tree-sitter-scala.rev}";
            source = inputs.tree-sitter-scala;
          };

          tree-sitter-tsx-master = inputs.ts-build.lib.buildGrammar p {
            language = "tsx";
            version = "${inputs.tree-sitter-typescript.version}-${inputs.tree-sitter-typescript.rev}";
            source = inputs.tree-sitter-typescript;
          };
        };

        neovimOverlay = f: p: {
          neovim-nightly = inputs.neovim-nightly-flake.packages.${system}.neovim;
        };

        pkgs = import nixpkgs {
          inherit system;
          config = { allowUnfree = true; };
          overlays = [ libOverlay pluginOverlay metalsOverlay neovimOverlay nmdOverlay tsOverlay ];
        };

        default-ide = pkgs.callPackage ./lib/ide.nix {
          inherit pkgs neovimBuilder;
        };

        searchdocs = pkgs.callPackage ./docs/search { };

        docbook = with import ./docs { inherit pkgs; inherit (pkgs) lib; }; {
          inherit manPages jsonModuleMaintainers;
          inherit (manual) html;
          inherit (options) json;
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
          inherit (pkgs) neovim-nightly neovimPlugins;
        };

        nixosModules.hm = {
          imports = [
            ./lib/hm.nix
            { nixpkgs.overlays = [ overlays.default ]; }
          ];
        };

        packages = {
          default = default-ide.full.neovim;

          # Documentation
          docs = docbook.html;
          docs-json = searchdocs.json;
          docs-search = searchdocs.html;

          # CI package
          ts-scala = pkgs.tree-sitter-scala-master;
          inherit (pkgs) metals;
          inherit (pkgs.neovimPlugins) nvim-treesitter;

          # Main languages enabled
          ide = default-ide.full.neovim;

          # Only Haskell (quite heavy)
          haskell = default-ide.haskell.neovim;

          # Only Scala with different themes
          scala = default-ide.scala.neovim;
          scala-nightly = default-ide.scala-nightly.neovim;
          scala-rose-pine = default-ide.scala-rose-pine.neovim;
          scala-tokyo-night = default-ide.scala-tokyo-night.neovim;

          # Neovim configuration files
          ide-neovim-rc = default-ide.full.neovimRC;
          haskell-neovim-rc = default-ide.haskell.neovimRC;
          scala-neovim-rc = default-ide.scala.neovimRC;

          # Lua configuration files
          ide-lua-rc = default-ide.full.luaRC;
          haskell-lua-rc = default-ide.haskell.luaRC;
          scala-lua-rc = default-ide.scala.luaRC;
        };
      }
    );
}

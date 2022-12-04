# neovim-flake

Nix flake for neovim with configuration options

Originally based on Jordan Isaacs' amazing [neovim-flake](https://github.com/jordanisaacs/neovim-flake)

## Try it out

```console
$ cachix use gvolpe-nixos # Optional: it'll save you CPU resources and time
$ nix run github:gvolpe/neovim-flake
```

By default, LSP support is enabled for Scala, Dhall, Elm, Nix, Haskell, and Smithy.

## Screenshot

![screenshot](./screenshot.png)

## Home Manager

First of all, we add the input flake.

```nix
{
  neovim-flake = {
    url = github:gvolpe/neovim-flake;
    inputs.nixpkgs.follows = "nixpkgs";
  };
}
```

Followed by importing the HM module.

```nix
{
  imports = [ neovim-flake.nixosModules.hm ];
}
```

Then we should be able to use the given module. E.g.

```nix
{
  programs.neovim-ide = {
    enable = true;
    settings = {
      vim.viAlias = false;
      vim.vimAlias = true;
      vim.lsp = {
        enable = true;
      };
    };
  };
}
```

For the Scala module, the `metals` binary can be easily overridden with the provided builder. E.g.

```nix
{
  vim.lsp = {
    enable = true;
    scala = {
      enable = true;
      metals = pkgs.metalsBuilder {
        version = "0.11.8+76-22425a8b-SNAPSHOT";
        outputHash = "[Insert hash (try nix build .#)]";
      };
      type = "nvim-metals"; # or nvim-lspconfig
    };
  };
}
```

We can also choose to use the minimal configuration via `nvim-lspconfig` or use the more featureful [nvim-metals](https://github.com/scalameta/nvim-metals) (default and recommended).

NOTE: To use `metalsBuilder`, you need to add the following overlay.

```nix
{
  pkgs = import nixpkgs {
    inherit system;
    overlays = [ neovim-flake.overlays.default ];
  };
}
```

Have a look at my [nix-config](https://github.com/gvolpe/nix-config) for a full example.

## Options

The philosophy behind this flake configuration is sensible options. While the default package has almost everything enabled, when building your own config using the overlay everything is disabled. By enabling a plugin or language, it will set up the keybindings and plugin automatically. Additionally each plugin knows when another plugin is enabled allowing for smart configuration of keybindings and automatic setup of things like completion sources and languages.

A goal of mine is that I shouldn't not be able to break neovim by enabling or disabling an option. For example you can't have two completion plugins enabled as the option is an enum.

## Language Support

Most languages use [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) to set up language server. Additionally some languages also (or exclusively) use [null-ls](https://github.com/jose-elias-alvarez/null-ls.nvim) to extend capabilities.

### Nix

**LSP Server**: [rnix-lsp](https://github.com/nix-community/rnix-lsp)

**Formatting**

rnix provides builtin formatting with [nixpkgs-fmt](https://github.com/nix-community/nixpkgs-fmt). 

### Elm

**LSP Server**: [elmls](https://github.com/elm-tooling/elm-language-server)

### Haskell

**LSP Server**: [hls](https://github.com/haskell/haskell-language-server)

### Scala

**LSP Server**: [metals](https://scalameta.org/metals/)

**Formatting**

Metals provides builtin formatting with [scalafmt](https://scalameta.org/scalafmt/).

**Plugins**

- [nvim-metals](https://github.com/scalameta/nvim-metals) enhances the metals experience.

### Dhall

**LSP Server**: [dhall-lsp-server](https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-lsp-server)

### SQL

**LSP Server**: [sqls](https://github.com/lighttiger2505/sqls)

**Formatting**

sqls provides formatting but it does not work very well so it is disabled. Instead using [sqlfluff](https://github.com/sqlfluff/sqlfluff) through null-ls.

**Linting**

Using [sqlfluff](https://github.com/sqlfluff/sqlfluff) through null-ls to provide linting diagnostics set at `information` severity.

**Plugins**

- [sqls.nvim](https://github.com/nanotee/sqls.nvim) for useful actions that leverage `sqls` LSP

### Rust

**LSP Server**: [rust-analyzer](https://github.com/rust-analyzer/rust-analyzer)

**Formatting**

Rust analyzer provides builtin formatting with [rustfmt](https://github.com/rust-lang/rustfmt)

**Plugins**

- [rust-tools](https://github.com/simrat39/rust-tools.nvim)
- [crates.nvim](https://github.com/Saecki/crates.nvim)

### C/C++

**LSP Server**: [ccls](https://github.com/MaskRay/ccls)

### Typescript

**LSP Server**: [typescript-language-server](https://github.com/typescript-language-server/typescript-language-server)

**Linting**

Using [eslint](https://github.com/prettier/prettier) through null-ls.

**Formatting**

Disabled lsp server formatting, using [prettier](https://github.com/prettier/prettier) through null-ls.

### Python

**LSP Server**: [pyright](https://github.com/microsoft/pyright)

**Formatting**:

Using [black](https://github.com/psf/black) through null-ls

### Markdown

**Plugins**

- [glow.nvim](https://github.com/ellisonleao/glow.nvim) for preview directly in neovim buffer

### HTML

**Plugins**

- [nvim-ts-autotag](https://github.com/ellisonleao/glow.nvim/issues/44) for autoclosing and renaming html tags. Works with html, tsx, vue, svelte, and php

### Smithy

**LSP Server**: [smithy-language-server](https://github.com/disneystreaming/smithy-language-server)

**Treesitter grammar**: [tree-sitter-smithy](https://github.com/indoorvivants/tree-sitter-smithy)

## All Plugins

A list of all plugins that can be enabled

### LSP

- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) common configurations for built-in language server
- [null-ls.nvim](https://github.com/jose-elias-alvarez/null-ls.nvim) neovim as a language server to inject LSP diagnostics, code actions, etc.
- [lspsaga.nvim](https://github.com/glepnir/lspsaga.nvim) useful UI and tools for lsp
- [trouble.nvim](https://github.com/folke/trouble.nvim) pretty list of lsp data
- [nvim-code-action-menu](https://github.com/weilbith/nvim-code-action-menu) a better code action menu with diff support
- [lsp-signature](https://github.com/ray-x/lsp_signature.nvim) show function signatures as you type
- [lspkind-nvim](https://github.com/onsails/lspkind-nvim) for pictograms in lsp (with support for nvim-cmp)

### Buffers

- [nvim-bufferline-lua](https://github.com/akinsho/bufferline.nvim) a buffer line with tab integration
- [bufdelete-nvim](https://github.com/famiu/bufdelete.nvim) delete buffers without losing window layout

### Comments

- [kommentary](https://github.com/b3nj5m1n/kommentary) comment text in and out, written in lua
- [nerdcommenter](https://github.com/preservim/nerdcommenter) comment functions so powerful—no comment necessary
- [todo-comments](https://github.com/folke/todo-comments.nvim) highlight, list and search todo comments

### Statuslines

- [lualine.nvim](https://github.com/hoob3rt/lualine.nvim) statusline written in lua.

### Filetrees

- [nvim-tree-lua](https://github.com/kyazdani42/nvim-tree.lua) a file explorer tree written in lua. Using

### Git

- [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) a variety of git decorations

### Treesitter

- Nix installation of treesitter
- [nvim-treesitter-context](https://github.com/romgrk/nvim-treesitter-context) a context bar using tree-sitter
- [nvim-ts-autotag](https://github.com/windwp/nvim-ts-autotag) uses treesitter to autoclose/rename html tags

### Visuals

- [indent-blankline](https://github.com/lukas-reineke/indent-blankline.nvim) for indentation guides
- [nvim-web-devicons](https://github.com/kyazdani42/nvim-web-devicons) Plugins and colors for icons. Requires patched font

### Utilities

- [telescope](https://github.com/nvim-telescope/telescope.nvim) an extendable fuzzy finder of lists. Working ripgrep and fd
- [which-key](https://github.com/folke/which-key.nvim) a popup that displays possible keybindings of command being typed

### Markdown

- [glow.nvim](https://github.com/ellisonleao/glow.nvim) a markdown preview directly in neovim using glow

### Completions

- [nvim-compe](https://github.com/hrsh7th/nvim-compe) A deprecated autocomplete plugin
- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) a completion engine that utilizes sources (replaces nvim-compe)
    - [cmp-buffer](https://github.com/hrsh7th/cmp-buffer) a source for buffer words
    - [cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp) a source for builtin LSP client
    - [cmp-vsnip](https://github.com/hrsh7th/cmp-vsnip) a source for vim-vsnip autocomplete
    - [cmp-path](https://github.com/hrsh7th/cmp-path) a source for path autocomplete
    - [cmp-treesitter](https://github.com/ray-x/cmp-treesitter) treesitter nodes autcomplete
    - [crates.nvim](https://github.com/Saecki/crates.nvim) autocompletion of rust crate versions in `cargo.toml`

### Snippets

- [vim-vsnip](https://github.com/hrsh7th/vim-vsnip) a snippet plugin that supports LSP/VSCode's snippet format

### Autopairs

- [nvim-autopairs](https://github.com/windwp/nvim-autopairs) an autopair plugin for neovim

### Themes

- [onedark](https://github.com/navarasu/onedark.nvim) a dark colorscheme with multiple options
- [nightfox](https://github.com/EdenEast/nightfox.nvim) a highly customizable theme with treesitter support
- [tokyonight-nvim](https://github.com/folke/tokyonight.nvim) a neovim theme with multiple color options

### Folds 

- [nvim-ufo](https://github.com/kevinhwang91/nvim-ufo) enhance "ultra fold" experience for neovim

### Dependencies

- [plenary](https://github.com/nvim-lua/plenary.nvim) which is a dependency of some plugins, installed automatically if needed
- [promise-async](https://github.com/kevinhwang91/promise-async) a dependency of nvim-ufo

{ pkgs, inputs, plugins, lib ? pkgs.lib, ... }:

final: prev:

with lib;
with builtins;

let
  inherit (prev.vimUtils) buildVimPluginFrom2Nix;

  treesitterGrammars = final.tree-sitter.withPlugins (p: [
    p.tree-sitter-c
    p.tree-sitter-scala
    p.tree-sitter-nix
    p.tree-sitter-elm
    p.tree-sitter-haskell
    p.tree-sitter-python
    p.tree-sitter-rust
    p.tree-sitter-markdown
    p.tree-sitter-comment
    p.tree-sitter-toml
    p.tree-sitter-make
    p.tree-sitter-tsx
    p.tree-sitter-html
    p.tree-sitter-javascript
    p.tree-sitter-css
    p.tree-sitter-graphql
    p.tree-sitter-json
  ]);

  buildPlug = name:
    buildVimPluginFrom2Nix {
      pname = name;
      version = "master";
      src = builtins.getAttr name inputs;
      postPatch =
        if (name == "nvim-treesitter")
        then ''
          rm -r parser
          ln -s ${treesitterGrammars} parser
        ''
        else "";
    };

  vim-scala3 = prev.vimUtils.buildVimPlugin {
    name = "vim-scala3";
    src = inputs.vim-scala;
  };

  vimPlugins = {
    inherit (pkgs.vimPlugins) nerdcommenter;
    inherit vim-scala3;
  };
in
{
  neovimPlugins =
    let
      xs = listToAttrs (map (n: nameValuePair n (buildPlug n)) plugins);
    in
    vimPlugins // xs;
}

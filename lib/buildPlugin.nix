{ pkgs, inputs, plugins, lib ? pkgs.lib, ... }:

final: prev:

with lib;
with builtins;

let
  inherit (prev.vimUtils) buildVimPluginFrom2Nix;

  tree-sitter-scala3 = inputs.ts-build.lib.buildGrammar pkgs {
    language = "scala";
    version = "eed3si9n-fork";
    source = inputs.tree-sitter-scala;
  };

  ts = prev.tree-sitter.override {
    extraGrammars = { inherit tree-sitter-scala3; };
  };

  treesitterGrammars = ts.withPlugins (p: [
    p.tree-sitter-c
    p.tree-sitter-scala3
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
    p.tree-sitter-smithy
  ]);

  smithy-lsp = pkgs.callPackage ./smithy-lspconfig.nix { };

  smithyLspHook = ''
    cat >> $out/lua/lspconfig/server_configurations/smithy.lua <<EOL
    ${smithy-lsp.lua}
    EOL
  '';

  # without adding `list.smithy`, highlights are ignored
  smithyParserHook = ''
    substituteInPlace $out/lua/nvim-treesitter/parsers.lua \
      --replace 'list.agda = {' '
        list.smithy = {
          install_info = {
            url = "https://github.com/indoorvivants/tree-sitter-smithy",
            branch = "main",
            files = { "src/parser.c" },
            generate_requires_npm = true,
          },
          filetype = "smithy",
          maintainers = { "@gvolpe" },
        }

        list.agda = {
      '
  '';

  nvimTreesitterHook = ''
    rm -r parser
    ln -s ${treesitterGrammars} parser
    mkdir -p $out/queries/smithy
    cp ${ts.builtGrammars.tree-sitter-smithy}/queries/highlights.scm $out/queries/smithy/highlights.scm
  '';

  buildPlug = name:
    buildVimPluginFrom2Nix {
      pname = name;
      version = "master";
      src = builtins.getAttr name inputs;
      preFixup = ''
        ${writeIf (name == "nvim-lspconfig") smithyLspHook}
        ${writeIf (name == "nvim-treesitter") smithyParserHook}
      '';
      postPatch = ''
        ${writeIf (name == "nvim-treesitter") nvimTreesitterHook}
      '';
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
    xs // vimPlugins;
}

{ pkgs, inputs, plugins, lib ? pkgs.lib, ... }:

final: prev:

with lib;
with builtins;

let
  inherit (prev.vimUtils) buildVimPlugin;

  ts = prev.tree-sitter.override {
    extraGrammars = {
      tree-sitter-scala = final.tree-sitter-scala-master;
    };
  };

  smithy-lsp = pkgs.callPackage ./smithy-lspconfig.nix { };

  smithyLspHook = ''
    cat >> $out/lua/lspconfig/server_configurations/smithy.lua <<EOL
    ${smithy-lsp.lua}
    EOL
  '';

  # sync queries of tree-sitter-scala and nvim-treesitter
  queriesHook = ''
    cp ${inputs.tree-sitter-scala}/queries/scala/* $out/queries/scala/
    cp ${ts.builtGrammars.tree-sitter-smithy}/queries/highlights.scm $out/queries/smithy/highlights.scm
  '';

  telescopeFixupHook = ''
    substituteInPlace $out/scripts/vimg \
      --replace "ueberzug layer" "${pkgs.ueberzug}/bin/ueberzug layer"
    substituteInPlace $out/lua/telescope/_extensions/media_files.lua \
      --replace "M.base_directory .. '/scripts/vimg'" "'$out/scripts/vimg'"
  '';

  tsPreFixupHook = ''
    ${queriesHook}
  '';

  tsPostPatchHook = grammars: ''
    rm -r parser
    ln -s ${grammars} parser
  '';

  buildPlug = name: grammars: buildVimPlugin {
    pname = name;
    version = "master";
    src = builtins.getAttr name inputs;
    preFixup = ''
      ${writeIf (name == "nvim-lspconfig") smithyLspHook}
      ${writeIf (name == "nvim-treesitter") tsPreFixupHook}
      ${writeIf (name == "telescope-media-files") telescopeFixupHook}
    '';
    postPatch = ''
      ${writeIf (name == "nvim-treesitter") (tsPostPatchHook grammars)}
    '';
  };

  vimPlugins = {
    inherit (pkgs.vimPlugins) nerdcommenter;
  };
in
rec {
  # override at use site with your own preferences
  treesitterGrammars = t: t.withPlugins (p: [
    p.tree-sitter-scala
    p.tree-sitter-nix
    p.tree-sitter-elm
    p.tree-sitter-haskell
    p.tree-sitter-markdown
    p.tree-sitter-markdown-inline
    p.tree-sitter-smithy
  ]);

  neovimPlugins =
    let
      tg = treesitterGrammars ts;
      xs = listToAttrs (map (n: nameValuePair n (buildPlug n tg)) plugins);
    in
    xs // vimPlugins;
}

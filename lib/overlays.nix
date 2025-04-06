{ lib, inputs, system }:

let
  pluginOverlay = lib.buildPluginOverlay;
  nmdOverlay = inputs.nmd.overlays.default;

  buildersOverlay = f: p: {
    inherit (lib) metalsBuilder neovimBuilder;
  };

  libOverlay = f: p: {
    lib = p.lib.extend (_: _: {
      inherit (lib) mkVimBool withAttrSet withPlugins writeIf;
    });
  };

  tsOverlay = f: p: {
    tree-sitter-scala-master = p.tree-sitter.buildGrammar {
      language = "scala";
      version = inputs.tree-sitter-scala.rev;
      src = inputs.tree-sitter-scala;
    };
  };

  neovimOverlay = f: p: {
    neovim-nightly = inputs.neovim-nightly-overlay.packages.${system}.neovim;
    neovim-version = nvim:
      if nvim.version == "nightly"
      then "nightly-${inputs.neovim-nightly-overlay.inputs.neovim-src.shortRev}"
      else nvim.version;
  };

  nixdOverlay = f: p: {
    inherit (inputs.nil.packages.${system}) nil;
    inherit (inputs.nixd.packages.${system}) nixd;
  };
in
[
  libOverlay
  buildersOverlay
  pluginOverlay
  nmdOverlay
  tsOverlay
  lib.metalsOverlay
  neovimOverlay
  nixdOverlay
]

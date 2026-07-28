{ inputs, lib, system }:

let
  pluginOverlay = lib.buildPluginOverlay;
  nmdOverlay = inputs.nmd.overlays.default;

  buildersOverlay = f: p: {
    metalsBuilder = import ./metalsBuilder.nix { pkgs = p; };
    neovimBuilder = import ./neovimBuilder.nix { pkgs = f; };
  };

  libOverlay = f: p: {
    lib = p.lib.extend (_: _: {
      inherit (lib) mkVimBool withAttrSet withPlugins writeIf;
    });
  };

  tsOverlay = f: p: {
    tree-sitter-scala-master = p.tree-sitter.buildGrammar {
      language = "scala";
      src = inputs.tree-sitter-scala;
      version = inputs.tree-sitter-scala.rev;
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
    inherit (inputs.typenix.packages.${system}) typenix;
  };

  flakeOverlay = f: p: {
    default-ide = p.callPackage ./ide.nix { };
    searchdocs = p.callPackage ../docs/search { };

    docbook = with import ../docs { pkgs = p; lib = p.lib; }; {
      inherit manPages jsonModuleMaintainers;
      inherit (manual) html;
      inherit (options) json;
    };
  };
in
[
  libOverlay
  buildersOverlay
  pluginOverlay
  nmdOverlay
  tsOverlay
  flakeOverlay
  lib.metalsOverlay
  neovimOverlay
  nixdOverlay
]

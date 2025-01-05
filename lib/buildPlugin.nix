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

  # sync queries of tree-sitter-scala and nvim-treesitter
  queriesHook = ''
    cp ${inputs.tree-sitter-scala}/queries/* $out/queries/scala/
    cp ${ts.builtGrammars.tree-sitter-smithy}/queries/highlights.scm $out/queries/smithy/highlights.scm
  '';

  telescopeFixupHook = ''
    substituteInPlace $out/scripts/vimg \
      --replace "chafa" "${pkgs.chafa}/bin/chafa"
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

  plenaryPostPatchHook = ''
    sed -Ei lua/plenary/curl.lua \
        -e 's@(command\s*=\s*")curl(")@\1${pkgs.curl}/bin/curl\2@'
  '';

  # following https://github.com/NixOS/nixpkgs/blob/d86ae899d2909c0899e4d3b29d90d5309771e77c/pkgs/applications/editors/vim/plugins/overrides.nix#L139
  buildPlug = name: grammars:
    let overrides = (final.callPackage ./plugins/overrides.nix { }) { p = name; };
    in buildVimPlugin {
      inherit name;
      inherit (overrides) checkInputs dependencies nvimRequireCheck nvimSkipModule;

      version = "master";
      src = lib.getAttr name inputs;

      doInstallCheck = name == "diffview" || name == "plenary-nvim";
      dontBuild = name == "nvim-metals";

      preFixup = ''
        ${writeIf (name == "nvim-treesitter") tsPreFixupHook}
        ${writeIf (name == "telescope-media-files") telescopeFixupHook}
      '';
      postPatch = ''
        ${writeIf (name == "nvim-treesitter") (tsPostPatchHook grammars)}
        ${writeIf (name == "plenary-nvim") plenaryPostPatchHook}
      '';
    };

  vimPlugins = {
    inherit (pkgs.vimPlugins) nerdcommenter;
  };

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
in
{
  inherit treesitterGrammars;

  neovimPlugins =
    let
      tg = treesitterGrammars ts;
      xs = listToAttrs (map (n: nameValuePair n (buildPlug n tg)) plugins);
    in
    xs // vimPlugins;
}

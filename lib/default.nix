{ inputs, pkgs, ... }:

let
  plugins =
    let
      f = xs: pkgs.lib.attrsets.filterAttrs (k: v: !builtins.elem k xs);

      nonPluginInputNames = [
        "self"
        "nixpkgs"
        "flake-utils"
        "neovim-nightly-flake"
        "nmd"
        "nixd"
        "tree-sitter-scala"
      ];
    in
    builtins.attrNames (f nonPluginInputNames inputs);
in
{
  buildPluginOverlay = import ./buildPlugin.nix { inherit pkgs inputs plugins; };
  metalsBuilder = import ./metalsBuilder.nix { inherit pkgs; };
  metalsOverlay = import ./metalsOverlay.nix { };
  mkVimBool = val: if val then 1 else 0;
  neovimBuilder = import ./neovimBuilder.nix { inherit pkgs; };
  withAttrSet = cond: attrSet: if cond then attrSet else { };
  withPlugins = cond: plugins: if cond then plugins else [ ];
  writeIf = cond: msg: if cond then msg else "";
}

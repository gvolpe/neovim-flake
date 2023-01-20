{ pkgs, lib ? pkgs.lib, ... }:

{ config }:

let
  vim = vimOptions.config.vim;

  vimOptions = lib.evalModules {
    modules = [
      { imports = [ ../modules ]; }
      config
    ];

    specialArgs = { inherit pkgs; };
  };
in
pkgs.wrapNeovim vim.neovim.package {
  viAlias = vim.viAlias;
  vimAlias = vim.vimAlias;
  configure = {
    customRC = vim.finalConfigRC;

    packages.myVimPackage = {
      start = builtins.filter (f: f != null) vim.startPlugins;
      opt = vim.optPlugins;
    };
  };
}

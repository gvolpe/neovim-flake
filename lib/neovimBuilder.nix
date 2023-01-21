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
rec {
  luaRC = pkgs.writeTextFile {
    name = "init.lua";
    text = ''
      ${vim.startLuaConfigRC}
      ${vim.luaConfigRC}
    '';
  };

  neovimRC = pkgs.writeTextFile {
    name = "init.vim";
    text = ''
      ${vim.finalConfigRC}

      ${vim.finalKeybindings}
    '';
  };

  finalConfigRC = ''
    ${vim.finalConfigRC}

    " Lua configuration
    lua << EOF
    ${luaRC.text}
    EOF

    ${vim.finalKeybindings}
  '';

  neovim = pkgs.wrapNeovim vim.neovim.package {
    viAlias = vim.viAlias;
    vimAlias = vim.vimAlias;
    configure = {
      customRC = finalConfigRC;

      packages.myVimPackage = {
        start = builtins.filter (f: f != null) vim.startPlugins;
        opt = vim.optPlugins;
      };
    };
  };
}

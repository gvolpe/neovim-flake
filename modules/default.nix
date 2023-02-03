{ config, lib, pkgs, ... }:

{
  imports = [
    ./autopairs
    ./basic
    ./comments
    ./completion
    ./core
    ./filetree
    ./fx
    ./git
    ./hop
    ./keys
    ./lsp
    ./markdown
    ./mind
    ./neoclip
    ./neovim
    ./plantuml
    ./scala
    ./snippets
    ./statusline
    ./surround
    ./tabline
    ./telescope
    ./theme
    ./todo
    ./treesitter
    ./visuals
  ];
}

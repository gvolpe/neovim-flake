{ config, lib, pkgs, ... }:

{
  imports = [
    ./completion
    ./comments
    ./theme
    ./core
    ./basic
    ./statusline
    ./tabline
    ./filetree
    ./visuals
    ./lsp
    ./scala
    ./treesitter
    ./autopairs
    ./snippets
    ./keys
    ./markdown
    ./telescope
    ./git
    ./hop
    ./todo
    ./mind
    ./plantuml
  ];
}

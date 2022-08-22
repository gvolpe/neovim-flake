{ config, lib, pkgs, ... }:

{
  imports = [
    ./shortcuts.nix
    ./which-key.nix
  ];
}

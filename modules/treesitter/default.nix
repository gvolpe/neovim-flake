{ pkgs, config, lib, ... }:

{
  imports = [
    ./treesitter.nix
    ./hlargs.nix
    ./context.nix
    ./config.nix
  ];
}

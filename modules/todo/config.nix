{ pkgs, config, lib, ... }:

with lib;

{
  config = {
    vim.todo.enable = mkDefault false;
  };
}

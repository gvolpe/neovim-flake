{ lib, ... }:

with lib;

{
  config = {
    vim.treesitter = {
      enable = mkDefault false;
      fold = mkDefault false;
      autotagHtml = mkDefault false;
      textobjects.enable = mkDefault false;
    };
  };
}

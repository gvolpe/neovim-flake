{ lib, ... }:

with lib;

{
  config = {
    vim.treesitter = {
      enable = mkDefault true;
      fold = mkDefault true;
      autotagHtml = mkDefault true;
      context.enable = mkDefault true;
      textobjects.enable = mkDefault true;
    };
  };
}

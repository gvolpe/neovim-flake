{ lib, ... }:

with lib;

{
  config = {
    vim.visuals = {
      enable = mkDefault false;

      modes.enable = mkDefault true;
      noice.enable = mkDefault true;
      nvimWebDevicons.enable = mkDefault false;
      lspkind.enable = mkDefault false;

      cursorWordline = {
        enable = mkDefault false;
        lineTimeout = mkDefault 500;
      };

      indentBlankline = {
        enable = mkDefault false;
        listChar = mkDefault "│";
        fillChar = mkDefault "⋅";
        eolChar = mkDefault "↴";
        showCurrContext = mkDefault true;
      };
    };
  };
}

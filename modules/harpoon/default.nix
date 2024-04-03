{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.vim.harpoon;
  keys = config.vim.keys.whichKey;
  tele = config.vim.telescope;
in
{
  options.vim.harpoon = {
    enable = mkOption {
      type = types.bool;
      description = "Enable the Harpoon plugin (better marks-based navigation)";
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins = [ pkgs.neovimPlugins.harpoon ];

    vim.luaConfigRC = ''
      require('harpoon'):setup()

      ${writeIf tele.enable ''
        vim.keymap.set("n", "<leader>hl", function() require("telescope").extensions.harpoon.marks() end, { desc = "List" })
      ''}

      ${writeIf keys.enable ''
        wk.register({
          ["<leader>h"] = {
            name = "Harpoon",
            a = { "<cmd>lua require('harpoon'):list():append()<CR>", "Add" },
            d = { "<cmd>lua require('harpoon'):list():remove()<CR>", "Del" },
          },
        })
      ''}
    '';
  };
}

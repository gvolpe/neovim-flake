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
        local themes = require("telescope.themes")
        local hm_actions = require("telescope._extensions.harpoon_marks.actions")

        vim.keymap.set(
          "n",
          "<leader>hl",
          function()
            require("telescope").extensions.harpoon.marks(themes.get_dropdown({
                previewer = false,
                layout_config = { width = 0.6 },
                path_display = { truncate = 10 },
                attach_mappings = function(_, map)
                    map("i", "<c-d>", hm_actions.delete_mark_selections)
                    map("n", "<c-d>", hm_actions.delete_mark_selections)
                    return true
                end,
            }))
          end,
          { desc = "List" }
        )
      ''}

      ${writeIf keys.enable ''
        wk.add({
          { "<leader>h", group = "Harpoon" },
          { "<leader>ha", "<cmd>lua require('harpoon'):list():add()<CR>", desc = "Add" },
          { "<leader>hd", "<cmd>lua require('harpoon'):list():remove()<CR>", desc = "Del" },
        })
      ''}
    '';
  };
}

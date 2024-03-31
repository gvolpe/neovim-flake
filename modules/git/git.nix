{ pkgs, config, lib, ... }:

with lib;
with builtins;

let
  cfg = config.vim.git;
  keys = config.vim.keys.whichKey;
in
{
  options.vim.git = {
    enable = mkOption {
      type = types.bool;
      description = "Enable git plugins";
    };

    gitsigns.enable = mkOption {
      type = types.bool;
      description = "Enable git options";
    };
  };

  config =
    mkIf cfg.enable {
      vim.startPlugins =
        (withPlugins cfg.enable [ pkgs.neovimPlugins.vim-fugitive ]) ++
        (withPlugins (cfg.enable && cfg.gitsigns.enable) [ pkgs.neovimPlugins.gitsigns-nvim ]);

      vim.luaConfigRC = mkIf cfg.gitsigns.enable ''
        -- GitSigns setup
        require('gitsigns').setup {
          on_attach = function(bufnr)
            local gs = package.loaded.gitsigns

            local function map(mode, l, r, opts)
              opts = opts or {}
              opts.buffer = bufnr
              vim.keymap.set(mode, l, r, opts)
            end

            -- Navigation
            local function nextHunk()
              if vim.wo.diff then return ']c' end
              vim.schedule(function() gs.next_hunk() end)
              return '<Ignore>'
            end

            local function prevHunk()
              if vim.wo.diff then return '[c' end
              vim.schedule(function() gs.prev_hunk() end)
              return '<Ignore>'
            end

            -- Actions
            ${writeIf keys.enable ''
            wk.register({
              ["<leader>g"] = {
                name = "Gitsigns",
                b = { function() gs.blame_line{full=true} end, "Blame (full)" },
                tb = { gs.toggle_current_line_blame, "Toggle blame" },
                td = { gs.toggle_deleted, "Toggle deleted" },
                d = { gs.diffthis, "Diff current file" },
                D = { function() gs.diffthis('~') end, "Diff file" },
                n = { nextHunk, "Next hunk" },
                p = { prevHunk, "Previous hunk" },
                r = { gs.reset_hunk, "Reset hunk" },
                s = { gs.stage_hunk, "Stage hunk" },
                S = { gs.stage_buffer, "Stage buffer" },
                u = { gs.undo_stage_hunk, "Undo stage hunk" },
                R = { gs.reset_buffer, "Reset buffer" },
              },
            })
            ''}

            -- Text object
            map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
          end
        }
      '';
    };
}

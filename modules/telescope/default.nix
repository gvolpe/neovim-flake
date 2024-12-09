{ pkgs, config, lib, ... }:

with lib;
with builtins;

let
  cfg = config.vim.telescope;
  keys = config.vim.keys.whichKey;
in
{
  options.vim.telescope = {
    enable = mkEnableOption "enable telescope";

    mediaFiles = {
      enable = mkEnableOption "enable telescope-media-files extension";
    };

    tabs = {
      enable = mkEnableOption "enable search.nvim (enhances telescope with tab-based search)";
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins = with pkgs.neovimPlugins;
      [ telescope ] ++
      (withPlugins cfg.mediaFiles.enable [ telescope-media-files ]) ++
      (withPlugins cfg.tabs.enable [ telescope-tabs ]);

    vim.nnoremap =
      {
        "<leader>ff" = "<cmd> Telescope find_files<CR>";
        "<leader>fg" = "<cmd> Telescope live_grep<CR>";
        "<leader>fb" = "<cmd> Telescope buffers<CR>";
        "<leader>fh" = "<cmd> Telescope help_tags<CR>";
        "<leader>fk" = "<cmd> Telescope marks<CR>";

        "<leader>fvc" = "<cmd> Telescope git_commits<CR>";
        "<leader>fvb" = "<cmd> Telescope git_branches<CR>";
        "<leader>fvs" = "<cmd> Telescope git_status<CR>";
        "<leader>fvx" = "<cmd> Telescope git_stash<CR>";
      }
      // (
        withAttrSet config.vim.lsp.enable {
          "<leader>flsb" = "<cmd> Telescope lsp_document_symbols<CR>";
          "<leader>flsw" = "<cmd> Telescope lsp_workspace_symbols<CR>";

          "<leader>flr" = "<cmd> Telescope lsp_references<CR>";
          "<leader>fli" = "<cmd> Telescope lsp_implementations<CR>";
          "<leader>flD" = "<cmd> Telescope lsp_definitions<CR>";
          "<leader>flt" = "<cmd> Telescope lsp_type_definitions<CR>";
          "<leader>fld" = "<cmd> Telescope diagnostics<CR>";
        }
      ) // (
        withAttrSet cfg.mediaFiles.enable {
          "<leader>fi" = "<cmd> Telescope media_files<CR>";
        }
      ) // (
        withAttrSet config.vim.treesitter.enable {
          "<leader>fts" = "<cmd> Telescope treesitter<CR>";
        }
      );

    vim.luaConfigRC = ''
      ${writeIf cfg.mediaFiles.enable ''
      require("telescope").load_extension("media_files")
      ''}

      ${writeIf cfg.tabs.enable ''
      local builtin = require('telescope.builtin')
      require("search").setup({
        append_tabs = {
          {
            name = "Scala files",
            tele_func = function()
              builtin.fd({ find_command = { "${pkgs.fd}/bin/fd", "-e", "scala" } })
            end,
            available = function()
              local scalaFiles = vim.fn.glob("*.scala", ".") .. vim.fn.glob("*.sbt", ".")
              return not (scalaFiles == "")
            end
          }
        },
      })
      ''}

      ${writeIf keys.enable ''
        wk.register({
          ["<leader>f"] = {
            name = "Telescope",
          },
        })
      ''}

      require("telescope").setup {
        defaults = {
          vimgrep_arguments = {
            "${pkgs.ripgrep}/bin/rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case"
          },
          pickers = {
            find_command = {
              "${pkgs.fd}/bin/fd",
            },
          },
        },
        extensions = {
          media = {
            backend = "chafa",
            backend_options = {
              chafa = {
                move = true,
              },
            },
          },
          media_files = {
            filetypes = {"png", "webp", "jpg", "jpeg"},
            find_cmd = "${pkgs.fd}/bin/fd",
          }
        }
      }
    '';
  };
}

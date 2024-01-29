{ pkgs, config, lib, ... }:

with lib;
with builtins;

let
  cfg = config.vim.telescope;
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
        "<leader>ft" = "<cmd> Telescope<CR>";

        "<leader>fvcw" = "<cmd> Telescope git_commits<CR>";
        "<leader>fvcb" = "<cmd> Telescope git_bcommits<CR>";
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
          "<leader>fs" = "<cmd> Telescope treesitter<CR>";
        }
      );

    vim.luaConfigRC = ''
      ${writeIf cfg.mediaFiles.enable ''
      require("telescope").load_extension("media_files")
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
          media_files = {
            filetypes = {"png", "webp", "jpg", "jpeg"},
            find_cmd = "${pkgs.fd}/bin/fd",
          }
        }
      }
    '';
  };
}

{ pkgs, config, lib, ... }:

with lib;
with builtins;

let
  cfg = config.vim.tabline.nvimBufferline;
  keys = config.vim.keys.whichKey;
in
{
  options.vim.tabline.nvimBufferline = {
    enable = mkEnableOption "bufferline.nvim";
  };

  config = mkIf cfg.enable (
    let
      mouse = {
        right = "'vertical sbuffer %d'";
        close = ''
          function(bufnum)
            require("bufdelete").bufdelete(bufnum, false)
          end
        '';
      };
    in
    {
      vim.startPlugins = with pkgs.neovimPlugins; [
        (assert config.vim.visuals.nvimWebDevicons.enable; nvim-bufferline)
        bufdelete-nvim
      ];

      vim.nnoremap = {
        "<silent><leader>bn" = "<cmd> BufferLineCycleNext<CR>";
        "<silent><leader>bp" = "<cmd> BufferLineCyclePrev<CR>";
        "<silent><leader>bc" = "<cmd> BufferLinePick<CR>";
        "<silent><leader>bse" = "<cmd> BufferLineSortByExtension<CR>";
        "<silent><leader>bsd" = "<cmd> BufferLineSortByDirectory<CR>";
        "<silent><leader>bsi" = ":lua require'bufferline'.sort_buffers_by(function (buf_a, buf_b) return buf_a.id < buf_b.id end)<CR>";
        "<silent><leader>bmn" = "<cmd> BufferLineMoveNext<CR>";
        "<silent><leader>bmp" = "<cmd> BufferLineMovePrev<CR>";
        "<silent><leader>b1" = "<cmd> BufferLineGoToBuffer 1<CR>";
        "<silent><leader>b2" = "<cmd> BufferLineGoToBuffer 2<CR>";
        "<silent><leader>b3" = "<cmd> BufferLineGoToBuffer 3<CR>";
        "<silent><leader>b4" = "<cmd> BufferLineGoToBuffer 4<CR>";
        "<silent><leader>b5" = "<cmd> BufferLineGoToBuffer 5<CR>";
        "<silent><leader>b6" = "<cmd> BufferLineGoToBuffer 6<CR>";
        "<silent><leader>b7" = "<cmd> BufferLineGoToBuffer 7<CR>";
        "<silent><leader>b8" = "<cmd> BufferLineGoToBuffer 8<CR>";
        "<silent><leader>b9" = "<cmd> BufferLineGoToBuffer 9<CR>";
      };

      vim.luaConfigRC = ''
        require("bufferline").setup{
           options = {
              numbers = "both",
              close_command = ${mouse.close},
              right_mouse_command = ${mouse.right},
              indicator = {
                icon = '▎',
                style = 'icon'
              },
              buffer_close_icon = '',
              modified_icon = '●',
              close_icon = '',
              left_trunc_marker = '',
              right_trunc_marker = '',
              separator_style = "thin",
              max_name_length = 18,
              max_prefix_length = 15,
              tab_size = 18,
              show_buffer_icons = true,
              show_buffer_close_icons = true,
              show_close_icon = true,
              show_tab_indicators = true,
              persist_buffer_sort = true,
              enforce_regular_tabs = false,
              always_show_bufferline = true,
              offsets = {{filetype = "NvimTree", text = "File Explorer", text_align = "left"}},
              sort_by = 'extension',
              diagnostics = "nvim_lsp",
              diagnostics_indicator = function(count, level, diagnostics_dict, context)
                 local s = ""
                 for e, n in pairs(diagnostics_dict) do
                    local sym = e == "error" and ""
                       or (e == "warning" and "" or "" )
                    if(sym ~= "") then
                    s = s .. " " .. n .. sym
                    end
                 end
                 return s
              end,
              numbers = function(opts)
                return string.format('%s·%s', opts.raise(opts.id), opts.lower(opts.ordinal))
              end,
           }
        }

        vim.diagnostic.config { update_in_insert = true }

        ${writeIf keys.enable ''
          wk.add({
            {"<leader>b", group = "Buffers" },
          })
        ''}
      '';
    }
  );
}

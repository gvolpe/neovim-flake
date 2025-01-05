{ curl, neovimPlugins, ... }:

# https://github.com/NixOS/nixpkgs/blob/d86ae899d2909c0899e4d3b29d90d5309771e77c/pkgs/applications/editors/vim/plugins/overrides.nix#L139
let
  withDeps = cond: deps: if cond then deps else [ ];

  cmpSkip = [
    "cmp.matcher_spec"
    "cmp.source_spec"
    "cmp.types.lsp_spec"
    "cmp.context_spec"
    "cmp.core_spec"
    "cmp.utils.feedkeys_spec"
    "cmp.utils.async_spec"
    "cmp.utils.misc_spec"
    "cmp.utils.api_spec"
    "cmp.utils.binary_spec"
    "cmp.utils.keymap_spec"
    "cmp.utils.str_spec"
    "cmp.entry_spec"
  ];

  snackSkip = [
    # Requires setup call first
    "snacks.dashboard"
    "snacks.debug"
    "snacks.dim"
    "snacks.git"
    "snacks.indent"
    "snacks.input"
    "snacks.lazygit"
    "snacks.notifier"
    "snacks.scratch"
    "snacks.scroll"
    "snacks.terminal"
    "snacks.win"
    "snacks.words"
    "snacks.zen"
    # Optional trouble integration
    "trouble.sources.profiler"
  ];
in
{ p }: {
  checkInputs =
    (withDeps (p == "modes-nvim") [ neovimPlugins.nvim-cmp ]) ++
    (withDeps (p == "cmp-path") [ neovimPlugins.nvim-cmp ]) ++
    (withDeps (p == "cmp-vsnip") [ neovimPlugins.nvim-cmp ]);

  dependencies =
    (withDeps (p == "crates-nvim") [ neovimPlugins.plenary-nvim ]) ++
    (withDeps (p == "diffview") [ neovimPlugins.plenary-nvim ]) ++
    (withDeps (p == "harpoon") [ neovimPlugins.plenary-nvim ]) ++
    (withDeps (p == "mind-nvim") [ neovimPlugins.plenary-nvim ]) ++
    (withDeps (p == "neogit") [ neovimPlugins.plenary-nvim ]) ++
    (withDeps (p == "noice") [ neovimPlugins.nui-nvim ]) ++
    (withDeps (p == "nvim-chatgpt") (with neovimPlugins; [ nui-nvim plenary-nvim telescope ])) ++
    (withDeps (p == "nvim-metals") [ neovimPlugins.plenary-nvim ]) ++
    (withDeps (p == "nvim-treesitter-textobjects") [ neovimPlugins.nvim-treesitter ]) ++
    (withDeps (p == "nvim-ufo") [ neovimPlugins.promise-async ]) ++
    (withDeps (p == "rust-tools") [ neovimPlugins.nvim-lspconfig ]) ++
    (withDeps (p == "telescope") [ neovimPlugins.plenary-nvim ]) ++
    (withDeps (p == "todo-comments") [ neovimPlugins.plenary-nvim ]);

  nvimRequireCheck =
    (withDeps (p == "crates-nvim") [ "crates" ]) ++
    (withDeps (p == "diffview") [ "diffview" ]) ++
    (withDeps (p == "harpoon") [ "harpoon" ]) ++
    (withDeps (p == "neogit") [ "neogit" ]) ++
    (withDeps (p == "noice") [ "noice" ]) ++
    (withDeps (p == "nvim-chatgpt") [ "chatgpt" ]) ++
    (withDeps (p == "nvim-metals") [ "metals" ]) ++
    (withDeps (p == "nvim-treesitter") [ "nvim-treesitter" ]) ++
    (withDeps (p == "nvim-ufo") [ "ufo" ]) ++
    (withDeps (p == "plenary-nvim") [ "plenary" ]) ++
    (withDeps (p == "todo-comments") [ "todo-comments" ]);

  nvimSkipModule =
    (withDeps (p == "indent-blankline") [ "ibl.config.types" ]) ++
    (withDeps (p == "nvim-autopairs") [ "nvim-autopairs.completion.cmp" "nvim-autopairs.completion.compe" ]) ++
    (withDeps (p == "nvim-bufferline") [ "bufferline.commands" ]) ++
    (withDeps (p == "nvim-cmp") cmpSkip) ++
    (withDeps (p == "nvim-neoclip") [ "neoclip.fzf" "neoclip.telescope" ]) ++
    (withDeps (p == "nvim-notify") [ "notify.integrations.fzf" ]) ++
    (withDeps (p == "nvim-treesitter-context") [ "install_parsers" ]) ++
    (withDeps (p == "nvim-surround") [ "nvim-surround.queries" ]) ++
    (withDeps (p == "onedark") [ "barbecue.theme.onedark" "onedark.highlights" "onedark.colors" "onedark.terminal" ]) ++
    (withDeps (p == "snacks") snackSkip) ++
    (withDeps (p == "telescope-tabs") [ "search" "search.settings" "search.util" ]) ++
    (withDeps (p == "tide") [ "tide.render" "tide.api" "tide.panel" "tide" ]) ++
    (withDeps (p == "tokyonight") [ "tokyonight.docs" "tokyonight.extra.fzf" ]) ++
    (withDeps (p == "trouble") [ "trouble.docs" ]) ++
    (withDeps (p == "which-key") [ "which-key.docs" ]);
}

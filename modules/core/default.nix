{ config, lib, pkgs, ... }:

with lib;
with builtins;

let
  cfg = config.vim;

  mkMappingOption = it:
    mkOption ({
      default = { };
      type = with types; attrsOf (nullOr str);
    } // it);
in
{
  options.vim = {
    viAlias = mkOption {
      description = "Enable vi alias";
      type = types.bool;
      default = true;
    };

    vimAlias = mkOption {
      description = "Enable vim alias";
      type = types.bool;
      default = true;
    };

    startConfigRC = mkOption {
      description = "start of vimrc contents";
      type = types.lines;
      default = "";
    };

    finalConfigRC = mkOption {
      description = "built vimrc contents";
      type = types.lines;
      internal = true;
      default = "";
    };

    finalKeybindings = mkOption {
      description = "built Keybindings in vimrc contents";
      type = types.lines;
      internal = true;
      default = "";
    };

    configRC = mkOption {
      description = "vimrc contents";
      type = types.lines;
      default = "";
    };

    startLuaConfigRC = mkOption {
      description = "start of vim lua config";
      type = types.lines;
      default = "";
    };

    luaConfigRC = mkOption {
      description = "vim lua config";
      type = types.lines;
      default = "";
    };

    startPlugins = mkOption {
      description = "List of plugins to startup";
      default = [ ];
      type = with types; listOf (nullOr package);
    };

    optPlugins = mkOption {
      description = "List of plugins to optionally load";
      default = [ ];
      type = with types; listOf package;
    };

    globals = mkOption {
      default = { };
      description = "Set containing global variable values";
      type = types.attrs;
    };

    nnoremap =
      mkMappingOption { description = "Defines 'Normal mode' mappings"; };

    inoremap = mkMappingOption {
      description = "Defines 'Insert and Replace mode' mappings";
    };

    vnoremap = mkMappingOption {
      description = "Defines 'Visual and Select mode' mappings";
    };

    xnoremap =
      mkMappingOption { description = "Defines 'Visual mode' mappings"; };

    snoremap =
      mkMappingOption { description = "Defines 'Select mode' mappings"; };

    cnoremap =
      mkMappingOption { description = "Defines 'Command-line mode' mappings"; };

    onoremap = mkMappingOption {
      description = "Defines 'Operator pending mode' mappings";
    };

    tnoremap =
      mkMappingOption { description = "Defines 'Terminal mode' mappings"; };

    nmap = mkMappingOption { description = "Defines 'Normal mode' mappings"; };

    imap = mkMappingOption {
      description = "Defines 'Insert and Replace mode' mappings";
    };

    vmap = mkMappingOption {
      description = "Defines 'Visual and Select mode' mappings";
    };

    xmap = mkMappingOption { description = "Defines 'Visual mode' mappings"; };

    smap = mkMappingOption { description = "Defines 'Select mode' mappings"; };

    cmap =
      mkMappingOption { description = "Defines 'Command-line mode' mappings"; };

    omap = mkMappingOption {
      description = "Defines 'Operator pending mode' mappings";
    };

    tmap =
      mkMappingOption { description = "Defines 'Terminal mode' mappings"; };

    # Source: https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/programs/neovim.nix
    runtime = mkOption {
      default = { };
      example = literalExpression ''
        { "ftplugin/c.vim".text = "setlocal omnifunc=v:lua.vim.lsp.omnifunc"; }
      '';
      description = lib.mdDoc ''
        Set of files that have to be linked in {file}`runtime`.
      '';

      type = with types; attrsOf (submodule (
        { name, config, ... }:
        {
          options = {

            enable = mkOption {
              type = types.bool;
              default = true;
              description = lib.mdDoc ''
                Whether this /etc file should be generated.  This
                option allows specific /etc files to be disabled.
              '';
            };

            target = mkOption {
              type = types.str;
              description = lib.mdDoc ''
                Name of symlink.  Defaults to the attribute
                name.
              '';
            };

            text = mkOption {
              default = null;
              type = types.nullOr types.lines;
              description = lib.mdDoc "Text of the file.";
            };

            source = mkOption {
              type = types.path;
              description = lib.mdDoc "Path of the source file.";
            };

          };

          config = {
            target = mkDefault name;
            source = mkIf (config.text != null) (
              let name' = "neovim-runtime" + baseNameOf name;
              in mkDefault (pkgs.writeText name' config.text)
            );
          };
        }
      ));
    };
  };

  config =
    let
      filterNonNull = filterAttrs (name: value: value != null);
      globalsScript =
        mapAttrsFlatten (name: value: "let g:${name}=${toJSON value}")
          (filterNonNull cfg.globals);

      matchCtrl = match "Ctrl-(.)(.*)";
      mapKeyBinding = it:
        let
          groups = matchCtrl it;
        in
        if groups == null
        then it
        else "<C-${toUpper (head groups)}>${head (tail groups)}";
      mapVimBinding = prefix: mappings:
        mapAttrsFlatten (name: value: "${prefix} ${mapKeyBinding name} ${value}")
          (filterNonNull mappings);

      nmap = mapVimBinding "nmap" config.vim.nmap;
      imap = mapVimBinding "imap" config.vim.imap;
      vmap = mapVimBinding "vmap" config.vim.vmap;
      xmap = mapVimBinding "xmap" config.vim.xmap;
      smap = mapVimBinding "smap" config.vim.smap;
      cmap = mapVimBinding "cmap" config.vim.cmap;
      omap = mapVimBinding "omap" config.vim.omap;
      tmap = mapVimBinding "tmap" config.vim.tmap;

      nnoremap = mapVimBinding "nnoremap" config.vim.nnoremap;
      inoremap = mapVimBinding "inoremap" config.vim.inoremap;
      vnoremap = mapVimBinding "vnoremap" config.vim.vnoremap;
      xnoremap = mapVimBinding "xnoremap" config.vim.xnoremap;
      snoremap = mapVimBinding "snoremap" config.vim.snoremap;
      cnoremap = mapVimBinding "cnoremap" config.vim.cnoremap;
      onoremap = mapVimBinding "onoremap" config.vim.onoremap;
      tnoremap = mapVimBinding "tnoremap" config.vim.tnoremap;
    in
    {
      vim.finalConfigRC = ''
        " Basic configuration
        ${cfg.startConfigRC}

        " Global scripts
        ${concatStringsSep "\n" globalsScript}

        " Config RC
        ${cfg.configRC}
      '';

      vim.finalKeybindings = ''
        " Keybindings
        ${builtins.concatStringsSep "\n" nmap}
        ${builtins.concatStringsSep "\n" imap}
        ${builtins.concatStringsSep "\n" vmap}
        ${builtins.concatStringsSep "\n" xmap}
        ${builtins.concatStringsSep "\n" smap}
        ${builtins.concatStringsSep "\n" cmap}
        ${builtins.concatStringsSep "\n" omap}
        ${builtins.concatStringsSep "\n" tmap}
        ${builtins.concatStringsSep "\n" nnoremap}
        ${builtins.concatStringsSep "\n" inoremap}
        ${builtins.concatStringsSep "\n" vnoremap}
        ${builtins.concatStringsSep "\n" xnoremap}
        ${builtins.concatStringsSep "\n" snoremap}
        ${builtins.concatStringsSep "\n" cnoremap}
        ${builtins.concatStringsSep "\n" onoremap}
        ${builtins.concatStringsSep "\n" tnoremap}
      '';
    };
}

{ pkgs, lib, nmd ? pkgs.nmd }:

let
  # Make sure the used package is scrubbed to avoid actually instantiating derivations.
  scrubbedPkgsModule = {
    imports = [{
      _module.args = {
        pkgs = lib.mkForce (nmd.scrubDerivations "pkgs" pkgs);
        pkgs_i686 = lib.mkForce { };
      };
    }];
  };

  dontCheckDefinitions = { _module.check = false; };

  buildModulesDocs = args:
    nmd.buildModulesDocs ({
      moduleRootPaths = [ ./.. ];
      mkModuleUrl = path: "https://github.com/gvolpe/neovim-flake/blob/main/${path}";
      channelName = "main";
    } // args);

  modulesDocs = buildModulesDocs {
    modules = [
      { imports = [ ../modules ]; }
      dontCheckDefinitions
      scrubbedPkgsModule
    ];
    docBook.id = "neovim-flake-options";
  };

  docs = nmd.buildDocBookDocs {
    pathName = "neovim-flake";
    projectName = "Neovim Flake by Gabriel Volpe";
    modulesDocs = [ modulesDocs ];
    documentsDirectory = ./.;
    documentType = "book";
    theme = "night-owl";
    chunkToc = ''
      <toc>
        <d:tocentry xmlns:d="http://docbook.org/ns/docbook" linkend="book-neovim-flake-manual"><?dbhtml filename="index.html"?>
          <d:tocentry linkend="ch-options"><?dbhtml filename="options.html"?></d:tocentry>
        </d:tocentry>
      </toc>
    '';
  };
in
{
  options = {
    json = modulesDocs.json.override {
      path = "share/doc/neovim-flake/options.json";
    };
  };

  inherit (docs) manPages;

  manual = { inherit (docs) html htmlOpenTool; };

  jsonModuleMaintainers = pkgs.writeText "module-maintainers.json" (
    builtins.toJSON { inherit (lib.meta.maintainers) gvolpe; }
  );
}

{ busybox, jq, lib, mustache-go, nixosOptionsDoc, path, runCommandLocal, writeTextFile }:

let
  system = "x86_64-linux";

  eval = import (path + "/nixos/lib/eval-config.nix") {
    inherit system;
    modules = map (x: ../../modules + "/${x}") (builtins.attrNames (builtins.readDir ../../modules));
  };

  opts = (nixosOptionsDoc { options = eval.options; }).optionsJSON;

  templateMarkdown = writeTextFile {
    name = "markdown";
    text = builtins.readFile ./templates/markdown.mustache;
  };

  templateHTML = writeTextFile {
    name = "html";
    text = builtins.readFile ./templates/html.mustache;
  };

  # there's more likely a smarter way to do this with jq...
  replaceNixStore =
    "${busybox}/bin/sed 's~.*/nix/store/.*source/~\"https://github.com/gvolpe/neovim-flake/blob/main/~'";
in
{
  json = runCommandLocal "options.json" { inherit opts; } ''
    cat $opts/share/doc/nixos/options.json | \
    ${jq}/bin/jq '.| with_entries( select(.key|startswith("vim") ) )' | \
    ${replaceNixStore} | \
    ${jq}/bin/jq \
    > $out
  '';

  markdown = runCommandLocal "options.md" { inherit opts; } ''
    cat $opts/share/doc/nixos/options.json | \
    ${jq}/bin/jq '.| with_entries( select(.key|startswith("vim") ) ) | [to_entries[]] | {options: .}' | \
    ${replaceNixStore} | \
    ${jq}/bin/jq | \
    ${mustache-go}/bin/mustache ${templateMarkdown} \
    > $out
  '';

  html = runCommandLocal "options.html" { inherit opts; } ''
    cat $opts/share/doc/nixos/options.json | \
    ${jq}/bin/jq '.| with_entries( select(.key|startswith("vim") ) ) | [to_entries[]] | {options: .}' | \
    ${replaceNixStore} | \
    ${jq}/bin/jq | \
    ${mustache-go}/bin/mustache ${templateHTML} \
    > $out
  '';
}

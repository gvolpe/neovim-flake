# Adapted from https://github.com/pinpox/nixos licensed under GPL-3
{ busybox, jq, lib, mustache-go, nixosOptionsDoc, path, runCommandLocal, writeTextFile }:

let
  system = "x86_64-linux";

  eval = import (path + "/nixos/lib/eval-config.nix") {
    inherit system;
    modules = map (x: ../../modules + "/${x}") (builtins.attrNames (builtins.readDir ../../modules));
  };

  opts = (nixosOptionsDoc { inherit (eval) options; }).optionsJSON;

  htmlTemplate = writeTextFile {
    name = "html";
    text = builtins.readFile ./templates/html.mustache;
  };

  jqargs = ''
    .| with_entries( select(.key|startswith("vim") ) ) | [to_entries[]] | {options: .} |
    .options[].value.declarations[] |= {
      "module": sub("^/nix/store.*-source(?<path>.*)";"<\(.path)>"),
      "url": sub("^/nix/store.*-source/(?<path>.*)";"https://github.com/gvolpe/neovim-flake/blob/main/\(.path)")
    }
  '';
in
{
  json = runCommandLocal "options.json" { inherit opts; } ''
    cat $opts/share/doc/nixos/options.json | \
    ${jq}/bin/jq '${jqargs}' \
    > $out
  '';

  html = runCommandLocal "options.html" { inherit opts; } ''
    cat $opts/share/doc/nixos/options.json | \
    ${jq}/bin/jq '${jqargs}' | \
    ${mustache-go}/bin/mustache ${htmlTemplate} \
    > $out
  '';
}

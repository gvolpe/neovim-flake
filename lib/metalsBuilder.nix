{ pkgs, ... }:

{ version, outputHash }:

let
  deps = pkgs.stdenv.mkDerivation {
    name = "metals-${version}-deps";
    buildCommand = ''
      export COURSIER_CACHE=$(pwd)
      ${pkgs.coursier}/bin/cs fetch org.scalameta:metals_2.13:${version} \
        -r bintray:scalacenter/releases \
        -r sonatype:snapshots > deps
      mkdir -p $out/share/java
      cp $(< deps) $out/share/java/
    '';
    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    inherit outputHash;
  };
in
pkgs.metals.overrideAttrs (old: {
  inherit deps version;
  __intentionallyOverridingVersion = true;
  extraJavaOpts = old.extraJavaOpts + " -Dmetals.client=nvim-lsp";
})

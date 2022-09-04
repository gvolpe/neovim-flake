{ pkgs, ... }:

{ version, outputHash }:

let
  metalsDeps = pkgs.stdenv.mkDerivation {
    name = "metals-deps-${version}";
    buildCommand = ''
      export COURSIER_CACHE=$(pwd)
      ${pkgs.coursier}/bin/cs fetch org.scalameta:metals_2.13:${version} \
        -r bintray:scalacenter/releases \
        -r sonatype:snapshots > deps
      mkdir -p $out/share/java
      cp -n $(< deps) $out/share/java/
    '';
    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    inherit outputHash;
  };
in
pkgs.metals.overrideAttrs (old: {
  inherit version;
  extraJavaOpts = old.extraJavaOpts + " -Dmetals.client=nvim-lsp";
  buildInputs = [ metalsDeps ];
})

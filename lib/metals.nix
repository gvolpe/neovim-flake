self: super:

let
  version = "0.11.8+75-3ac5131a-SNAPSHOT";

  metalsDeps = super.stdenv.mkDerivation {
    name = "metals-deps-${version}";
    buildCommand = ''
      export COURSIER_CACHE=$(pwd)
      ${super.coursier}/bin/cs fetch org.scalameta:metals_2.13:${version} \
        -r bintray:scalacenter/releases \
        -r sonatype:snapshots > deps
      mkdir -p $out/share/java
      cp -n $(< deps) $out/share/java/
    '';
    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = "sha256-rAsep08ORewVpTmfkh46lcdtjn+XBZwc25HihbVuKCA=";
  };
in
{
  metals = super.metals.overrideAttrs (old: {
    inherit version;
    extraJavaOpts = old.extraJavaOpts + " -Dmetals.client=nvim-lsp";
    buildInputs = [ metalsDeps ];
  });
}

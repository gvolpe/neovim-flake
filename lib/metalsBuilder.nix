{ pkgs, ... }:

{ version, outputHash, withMcp ? pkgs.lib.versionAtLeast version "1.6.7" }:

let
  artifacts = [
    "org.scalameta:metals_2.13:${version}"
  ] ++ pkgs.lib.optional withMcp "org.scalameta:metals-mcp_2.13:${version}";

  deps = pkgs.stdenv.mkDerivation {
    name = "metals-${version}-deps";
    buildCommand = ''
      export COURSIER_CACHE=$(pwd)
      ${pkgs.coursier}/bin/cs fetch ${pkgs.lib.escapeShellArgs artifacts} > deps
      mkdir -p $out/share/java
      cp $(< deps) $out/share/java/
    '';
    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    inherit outputHash;
  };
in
(pkgs.metals.override {
  extraJavaOpts = "-XX:+UseG1GC -XX:+UseStringDeduplication -Xss4m -Xms100m -Dmetals.client=nvim-lsp";
}).overrideAttrs (finalAttrs: old: {
  inherit version;
  buildInputs = [ deps ];
  __intentionallyOverridingVersion = true;
  deps = deps;
  passthru = (old.passthru or { }) // {
    deps = deps;
    tests = (old.passthru.tests or { }) // {
      version = pkgs.testers.testVersion { package = finalAttrs.finalPackage; };
    };
  };
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/metals --version | grep -q "${finalAttrs.version}"
    ${pkgs.lib.optionalString withMcp ''
      $out/bin/metals-mcp --version | grep -q "${finalAttrs.version}"
    ''}

    runHook postInstallCheck
  '';
})
